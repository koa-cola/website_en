---
layout: default
id: public
title: public
prev: config-env.html
next: views.html
---

koa-cola默认的静态文件目录在public目录下，webpack默认的配置也是输出bundle到public目录，如果需要修改目录位置则需要修改koa中间件的配置。

在api/middlewares添加koa-static：

```javascript
export default function koaStatic (){
    return require('koa-static')('path/to/static')
}
```

然后在config下新建middlewares.js:

```javascript
module.exports = {
	middlewares : {
		'koa-static' : true
	}
};
```