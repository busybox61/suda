### 创建一个页面



---
#### 创建一个普通的HTML页面
打开页面： `http://test.atd3.org/dev.php/admin-panel` 会出现如下页面：

![管理面板登陆](img/signin.png)

当前页面是网站的默认管理页面（开发者用）只能从本地访问。默认密码是`dxkite`
密码通过修改文件`app/resource/config/config.json`的`debug-passwd`字段来修改

![配置文件](img/changpw.png)

登陆页面后，会进入到路由管理页面。在这个页面可以管理网站的所有
的对外URL和控制器。当前情况下会有suda模块和一个default模块，

![管理面板](img/delete_add.png)

点击上面的删除，删除index路由后，我们来添加个路由。

![添加路由](img/add.png)

当前面板下面会出现一个添加路由的页面，我们可以通过这个来编辑他，
我们添加我们的第一个路由，名字叫做
`score`
url表达式为 `/score`
访问类修改为 `Score`
其他的默认不动。
添加成功后，我们可以看到反馈:

![success](img/success.png)
记住这两个路径，我下节教程将会用到。

访问路由`http://test.atd3.org/dev.php/score` 后我们可以看到如下页面：

![添加成功](img/addsuccess.png)

添加页面的教程也就完成了。

#### 添加JSON返回页面

所有的东西如添加HTML页面一样，但是把响应格式修改为json就好，添加完后访问，可以得到如下效果：

![JSON](img/jsonrep.png)


### 使用问题 FAQ

**Q** : 如何修改页面内容？     

**A** : 找到页面响应类修改内容即可，响应类生成路径按命名空间映射路径，基命名空间为App目录下的`app.namespace`设置的命名空间

![manifast-namespace](img/manifast-namespace.png)

文件内容为模板创建的：

![class-template](img/class-template.png)

本例子的第一个创建的HTML页面响应的路径为:`app/modules/default/src/cn/atd3/response/test/Page1.php`
解释：`app/modules/模块名/src/基命名空间/response/命名空间/类名.php`

**Q** : 如何修改页面模板？     

**A** : 找到页面模板修改内容即可，模板调用遵循 `模块:路径`，主题默认为`default`

本例的一个HTML页面的响应模板路径为:`app/modules/default/resource/template/default/test/page1.tpl.html` 
对应解释： `app/modules/模块名/resource/template/模板样式/命名空间全小写/类名全小写.tpl.html` 

初始内容

![template-file](img/template-file.png)


具体模板使用请查看[模板使用](../../tools/template.md)