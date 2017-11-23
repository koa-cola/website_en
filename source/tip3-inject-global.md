---
layout: default
id: tip3-inject-global
title: Inject global
prev: tip2-redux.html
next: tip4-cluster.html
---

Somehow we want to require koa-cola project files but without running the project, if the file contain global refer which base on run-time like `app.xxx`, this will thow a exception, in this particular situation we need use `reqInject` to inject `global.app`.

```javascript
import { reqInject } from 'koa-cola'
let user;
reqInject(function(){
    // after injection, we can require any files inside project.
    user = require('./api/models/user').default 
    // or get the global variable directly
    let config = app.config;
});
```