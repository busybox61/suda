# Suda应用运行器

用于运行Suda框架编写好的应用

## 使用方式

**服务器上必须安装好Docker环境**

```
run-app.sh [options] app-path
options:
  --init         clear data and init app
  --upgrade      upgrade suda system
  --database     disable docker database
  --master       set use master branch(default:dev)
  --public       set public path to local
  --restart      restart app
  -p --port      set export port
  -d --data      set data path to local
```

## 参数说明

- --init 初始化数据
- --upgrade 更新Docker中的Suda框架代码
- --database 使用外部数据库
    
    数据库数据必须已经配置，默认链接本地的数据库即可
- --master 使用Suda主分支
- --public 挂载本地目录到docker目录下的 public
- --data 挂载本地数据目录
- --restart 如果应用启动了则重启
- --port 设置映射端口，默认80

## 注意

**Suda Package包为zip压缩包，压缩的内容为 app/ 目录下的文件**

