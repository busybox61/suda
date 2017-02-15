<?php
namespace suda\core;

use suda\tool\Command;
use suda\tool\Json;
use suda\tool\ArrayHelper;

class Router
{
    protected $mapper;
    protected $matchs=[];
    protected $types;
    protected static $urltype=['int'=>'\d+','string'=>'[^\/]+','longstring'=>'.+'];
    protected static $router=null;
    protected $routers=[];
    
    private function __construct()
    {
        Hook::listen('system:404', 'Router::error404');
        Hook::listen('Router:dispatch::error', 'Router::error404');
    }

    public static function getInstance()
    {
        if (is_null(self::$router)) {
            self::$router=new Router;
        }
        return self::$router;
    }

    public function load(string $module)
    {
        $routers=[];
        // 加载普通路由
        if (Storage::exist(MODULES_DIR.'/'.$module.'/resource/config/router.json')) {
            $routers=array_merge($routers, Json::loadFile(MODULES_DIR.'/'.$module.'/resource/config/router.json'));
        }
        // 加载管理路由
        if (Storage::exist(MODULES_DIR.'/'.$module.'/resource/config/router_admin.json')) {
            $routers=array_merge($routers, Json::loadFile(MODULES_DIR.'/'.$module.'/resource/config/router_admin.json'));
        }
        array_walk($routers, function (&$router) use ($module) {
            $router['module']=$module;
        });
        $this->routers=array_merge($this->routers, $routers);
    }

    protected function loadFile()
    {
        $this->routers=require TEMP_DIR.'/router.cache.php';
    }
    protected function saveFile()
    {
        ArrayHelper::export(TEMP_DIR.'/router.cache.php', '_router', $this->routers);
    }
    protected function loadModulesRouter()
    {
        if (conf('debug')) {
            $modules=Config::get('app.modules', []);
            foreach ($modules as $module) {
                self::load($module);
            }
            self::saveFile();
        } else {
            self::loadFile();
        }
    }

    public function watch(string $name, string $url)
    {
        $this->matchs[$name]=self::buildMatch($name, $url);
    }
    protected function matchRouterMap()
    {
        $request=Request::getInstance();
        foreach ($this->matchs as $name=>$preg) {
            if (preg_match('/^'.$preg.'$/', $request->url(), $match)) {
                
                // 检验接口参数
                if (isset($this->routers[$name]['method']) && count($this->routers[$name]['method'])>0) {
                    array_walk($this->routers[$name]['method'], 'strtolower');
                    // 方法不匹配
                    if (!in_array(strtolower($request->method()), $this->routers[$name]['method'])) {
                        continue;
                    }
                }
                
                array_shift($match);
                if (count($match)>0) {
                    foreach ($this->types[$name] as $param_name =>$type) {
                        $value=array_shift($match);
                        if ($type==='int') {
                            $value=intval($value);
                        } else {
                            $value=urldecode($value);
                        }
                        $request->set($param_name, $value);
                    }
                }
                return $name;
            }
        }
        return false;
    }

    protected function buildRouterMap()
    {
        foreach ($this->routers as $name => $router) {
            self::watch($name, $router['visit']);
        }
    }

    public static function visit(array $method, string $url, string $router, string $tag=null,bool $ob =true, bool $admin=false )
    {
        $params=self::getParams($url);
        if (!preg_match('/^(.+?)@(.+?)$/', $router, $matchs)) {
            return false;
        }

        // 解析变量
        list($router, $class_short, $module)=$matchs;
        // 路由位置
        $router_file=MODULES_DIR.'/'.$module.'/resource/config/router'.($admin?'_admin':'').'.json';
        $namespace=conf('app.namespace');
        // 类名
        $class=$namespace.'\\response\\'.$class_short;
        $params_str='// auto create params getter ...'."\r\n";
        foreach ($params as $param_name=>$param_type) {
            $params_str.="\t\t\${$param_name}=\$request->get()->{$param_name}(".(preg_match('/int/i', $param_type)?'0':'"hello!"').");\r\n";
        }
        $pos=strrpos($class, '\\');
        $class_namespace=substr($class, 0, $pos);
        $class_name=substr($class, $pos+1);
        $class_path=MODULES_DIR.'/'.$module.'/src/'.$class_namespace;
        $class_file=$class_path.'/'.$class_name.'.php';
        $template_file=MODULES_DIR.'/'.$module.'/resource/template/default/'.strtolower($class_short).'.tpl.html';
        $template_name=strtolower($class_short);
        $class_template= Storage::get(SYS_RES.'/class_template.php');
        $class_template=str_replace(
            [
                '#class_namespace#',
                '#class_name#',
                '#params_str#',
                '#module#',
                '#template_name#',
            ],
            [
                $class_namespace,
                $class_name,
                $params_str,
                $module,
                $template_name,
            ], $class_template);
        $template=Storage::get(SYS_RES.'/view_template.html');
        $template=str_replace('#create_url#', $url, $template);
        // 写入Class
        Storage::path($class_path);
        Storage::put($class_file, $class_template);
        // 写入模板
        Storage::path(dirname($template_file));
        Storage::put($template_file, $template);

        // 更新路由
        Storage::path(dirname($router_file));
        if (Storage::exist($router_file)) {
            $json=Json::loadFile($router_file);
        } else {
            $json=[];
        }
        $item=array(
            'class'=>$class,
            'visit'=>$url,
        );
        if (!$ob) {
            $item['ob']=false;
        }
        if (count($method)) {
            $item['method']=$method;
        }
        $tagname=is_null($tag)?preg_replace('/[\\\\]+/', '_', $class_short):$tag;
        $json[strtolower($tagname)]=$item;
        Json::saveFile($router_file, $json);
        return true;
    }

    public static function getParams(string $url)
    {
        $urltype=self::$urltype;
        $types=array();
        $url=preg_replace('/([\/\.\\\\\+\*\[\^\]\$\(\)\=\!\<\>\|\-])/', '\\\\$1', $url);
        $url=preg_replace_callback('/\{(?:(\w+)(?::(\w+)))\}/', function ($match) use (&$types, $urltype) {
            $param_name=$match[1]!==''?$match[1]:count($types);
            $param_type=isset($match[2])?$match[2]:'url';
            $types[$param_name]=$param_type;
        }, $url);
        return $types;
    }

    protected function buildMatch(string $name, string $url)
    {
        $types=&$this->types;
        $urltype=self::$urltype;
        $url=preg_replace('/([\/\.\\\\\+\*\[\^\]\$\(\)\=\!\<\>\|\-])/', '\\\\$1', $url);
        $url=preg_replace_callback('/\{(?:(\w+)(?::(\w+)))\}/', function ($match) use ($name, &$types, $urltype) {
            $size=isset($types[$name])?count($types[$name]):0;
            $param_name=$match[1]!==''?$match[1]:$size;
            $param_type=isset($match[2])?$match[2]:'url';
            $types[$name][$param_name]=$param_type;
            if (isset($urltype[$param_type])) {
                return '('.$urltype[$param_type].')';
            } else {
                return '(.+)';
            }
        }, $url);
        return $url;
    }

    public function buildUrl(string $name, array $values)
    {
        $url=DIRECTORY_SEPARATOR === '/'?'/':'/?/';
        if (isset($this->routers[$name])) {
            $url=preg_replace_callback('/\{(?:(\w+)(?::(\w+)))\}/', function ($match) use ($name, $values) {
                $param_name=$match[1];
                $param_type=isset($match[2])?$match[2]:'url';
                if (isset($values[$param_name])) {
                    if ($param_type==='int') {
                        return intval($values[$param_name]);
                    }
                    return $values[$param_name];
                } else {
                    return '';
                }
            }, $this->routers[$name]['url']);
        } else {
            return '_undefine_router';
        }
        return $url;
    }


    public function dispatch()
    {
        self::loadModulesRouter();
        self::buildRouterMap();
        // Hook前置路由（自定义过滤器|自定义路由）
        if (Hook::execIf('Router:dispatch::before', [Request::getInstance()], true)) {
            if (($router_name=self::matchRouterMap())!==false) {
                self::runRouter($this->routers[$router_name]);
            } else {
                Hook::exec('system:404');
            }
        } else {
            Hook::execTail('Router:dispatch::error');
        }
    }
    protected static function runRouter(array $router)
    {
        if (! (isset($router['ob']) && $router['ob']===false)) {
            Response::obStart();
        }
        (new \suda\tool\Command(Config::get('app.application').'::activeModule'))->exec([$router['module']]);
        (new \suda\tool\Command($router['class'].'->onRequest'))->exec([Request::getInstance()]);
    }

    public static function error404()
    {
        $render=new Response;
        $render->state(404);
        $render->display('suda:error404', ['path'=>Request::url()]);
    }
}