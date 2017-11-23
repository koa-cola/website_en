---
layout: default
id: views-app
title: app.tsx
prev: views-pages.html
next: views-components.html
---

<!-- views/app.tsx是浏览器端bundle的webpack入口文件，app.tsx可以手动维护，也可以由ko-cola生成。 -->
views/app.tsx is the entry file of webpack building, you can maintain the file if needed, and in this case it is better to use another file as the entry file, because if you run `koa-cola build` or `koa-cola dev`, will override the file.

<!-- 你可以手动维护这个文件，手动创建Provider和Router，并提供store： -->
custom your own webpack entry file with store provided like:

```javascript
const store = ...
<Provider store={store} key="provider">
    <Router history={browserHistory}>
        <Route ... />
    </Router>
</Provider>
```

<!-- 如果要使用服务器端的redux初始化数据，你需要正确的创建store： -->
if you want to seamlessly use the store initialized by server side, you need to create store with the initial data by `window.__data` rendered by koa-cola:
```javascript
const { ReduxAsyncConnect, asyncConnect, reducer } = require('koa-cola/client');
// __data is the server side redux store serialization
const store = createStore(combineReducers(Object.assign({ reduxAsyncConnect: reducer }, ...custom_reducer))
    , (window as any).__data);
```

<!-- 如果使用`koa-cola build`来build bundle，那么koa-cola会自动生成app.tsx，所以建议使用koa-cola的生成的方式来维护app.tsx。 -->
