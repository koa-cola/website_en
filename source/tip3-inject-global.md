---
layout: default
id: tip3-inject-global
title: Inject global全局注入
prev: tip2-redux.html
next: tip4-cluster.html
---

全局依赖注入，有时候在其他非应用运行时引用koa-cola里面的文件时，会因为文件依赖`app.xxx`而出错，使用inject global方式，可以实现第三方非koa-cola的require。
```javascript
import { reqInject } from 'koa-cola'
let user;
reqInject(function(){
    user = require('./api/models/user').default // 直接require项目内的文件
    let config = app.config; // 或者app当前配置
});
```