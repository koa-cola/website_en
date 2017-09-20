---
layout: default
id: views-app
title: app.tsx
prev: views-pages.html
next: views-components.html
---

views/app.tsx是浏览器端bundle的webpack入口文件，app.tsx可以手动维护，也可以由ko-cola生成。

你可以手动维护这个文件，手动创建Provider和Router，并提供store：

```javascript
const store = ...
<Provider store={store} key="provider">
    <Router history={browserHistory}>
        <Route ... />
    </Router>
</Provider>
```

如果要使用服务器端的redux初始化数据，你需要正确的创建store：
```javascript
const { ReduxAsyncConnect, asyncConnect, reducer } = require("koa-cola/dist/client").Decorators.view;
// 使用__data 作为redux的初始化数据
const store = createStore(combineReducers(Object.assign({ reduxAsyncConnect: reducer }, ...custom_reducer))
    , (window as any).__data);
```

如果使用`koa-cola build`来build bundle，那么koa-cola会自动生成app.tsx，所以建议使用koa-cola的生成的方式来维护app.tsx。