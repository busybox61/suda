#  Response 

> *文件信息* suda\core\Response.php: 30~295


网页响应类，用于处理来自服务器的请求


## 描述




## 常量列表
| 常量名  |  值|
|--------|----|
|EnableOutputBuffer | 1 | 


## 变量列表
| 可见性 |  变量名   | 说明 |
|--------|----|------|
| public  static  | name | | 
| protected    | type | | 

## 方法

| 可见性 | 方法名 | 说明 |
|--------|-------|------|
|  public  |[__construct](Response/__construct.md) |  |
|abstract  public  |[onRequest](Response/onRequest.md) |  |
|  public  static|[state](Response/state.md) |  |
|  public  static|[setName](Response/setName.md) |  |
|  public  static|[getName](Response/getName.md) |  |
|  public  |[type](Response/type.md) |  |
|  public  |[noCache](Response/noCache.md) |  |
|  public  |[json](Response/json.md) | 构建JSON输出 |
|  public  |[file](Response/file.md) | 直接输出文件 |
|  public  |[page](Response/page.md) | 输出HTML页面 |
|  public  |[view](Response/view.md) | 输出HTML页面 |
|  public  |[template](Response/template.md) | 输出模板 |
|  public  |[refresh](Response/refresh.md) |  |
|  public  |[forward](Response/forward.md) |  |
|  public  |[getForward](Response/getForward.md) |  |
|  public  |[setForward](Response/setForward.md) |  |
|  public  |[go](Response/go.md) |  |
|  public  |[redirect](Response/redirect.md) |  |
|  public  static|[etag](Response/etag.md) | 使用Etag |
|  public  static|[close](Response/close.md) |  |
|  public  static|[mime](Response/mime.md) | 页面MIME类型 |
|  public  static|[setHeader](Response/setHeader.md) | 安全设置Header值 |
|  public  static|[addHeader](Response/addHeader.md) |  |
|  protected  static|[_etag](Response/_etag.md) |  |
|  public  static|[statusMessage](Response/statusMessage.md) |  |
 

## 例子

example