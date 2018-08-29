#  Manager 

> *文件信息* suda\template\Manager.php: 29~670


模板管理类


## 描述



该类暂时无说明


## 变量列表
| 可见性 |  变量名   | 说明 |
|--------|----|------|
| public  static  | extRaw | 模板输入扩展| 
| public  static  | extCpl | 模板输出扩展| 
| protected  static  | theme | 默认样式| 
| protected  static  | templateSource | 模板搜索目录| 

## 方法

| 可见性 | 方法名 | 说明 |
|--------|-------|------|
|  public  static|[loadCompile](Manager/loadCompile.md) | 载入模板编译器 |
|  public  static|[setTemplate](Manager/setTemplate.md) | 设置模板基类 |
|  public  static|[getCompiler](Manager/getCompiler.md) | 获取编译器 |
|  public  static|[theme](Manager/theme.md) | 获取/设置模板样式 |
|  public  static|[compile](Manager/compile.md) | 编译文件 |
|  public  static|[display](Manager/display.md) | 根据模板ID显示HTML模板 |
|  public  static|[displaySource](Manager/displaySource.md) | 根据名称显示源 |
|  public  static|[displayFile](Manager/displayFile.md) | 根据路径显示模板 |
|  public  static|[prepareResource](Manager/prepareResource.md) | 准备静态资源 |
|  public  static|[moduleUniqueId](Manager/moduleUniqueId.md) | 获取模块唯一标识符 |
|  public  static|[getThemePath](Manager/getThemePath.md) | 模块模板文件目录 |
|  public  static|[getAppThemePath](Manager/getAppThemePath.md) | 模块模板文件目录 |
|  public  static|[addTemplateSource](Manager/addTemplateSource.md) | 设置模板源 |
|  public  static|[getTemplateSource](Manager/getTemplateSource.md) | 获取模板源 |
|  public  static|[registerTemplateSource](Manager/registerTemplateSource.md) | 注册模块模板资源目录 |
|  protected  static|[copyStatic](Manager/copyStatic.md) | 复制模板目录下静态文件 |
|  public  static|[file](Manager/file.md) | 编译动态文件 |
|  public  static|[include](Manager/include.md) |  |
|  public  static|[getInputFile](Manager/getInputFile.md) | 模板输入路径 |
|  public  static|[getOutputFile](Manager/getOutputFile.md) | 模板编译后输出路径 |
|  public  static|[className](Manager/className.md) |  |
|  public  static|[initResource](Manager/initResource.md) |  |
|  public  static|[findModuleTemplates](Manager/findModuleTemplates.md) |  |
|  protected  static|[_findModuleTemplate](Manager/_findModuleTemplate.md) |  |
|  public  static|[getStaticAssetPath](Manager/getStaticAssetPath.md) |  |
|  public  static|[getDynamicAssetPath](Manager/getDynamicAssetPath.md) |  |
|  public  static|[assetServer](Manager/assetServer.md) |  |
|  public  static|[checkSyntax](Manager/checkSyntax.md) | 检查语法 |
|  protected  static|[assetsResponse](Manager/assetsResponse.md) | 动态加载静态资源 |
 

## 例子

example