---
layout: default
id: tip3-inject-global
title: Inject global
prev: tip2-redux.html
next: tip4-cluster.html
---

<!-- 全局依赖注入，有时候在其他 非应用运行时引用koa-cola里面的文件时，会因为文件依赖`app.xxx`而出错，使用inject global方式，可以实现第三方非koa-cola的require。 -->
When somehow if we are not running koa-cola app, but want to require some file in the koa-cola, we must call `reqInject` to inject `global.app` to avoid any dependency loss, like `app.xxx`.

```javascript
import { reqInject } from 'koa-cola'
let user;
reqInject(function(){
    // after injection, we can require any files inside project.
    user = require('./api/models/user').default 
    // or get the injected variable
    let config = app.config;
});
```