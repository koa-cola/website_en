---
layout: default
id: views-app
title: app.tsx
prev: views-pages.html
next: views-components.html
---

views/app.tsx is the entry file of webpack building, you can maintain the file if needed, and in this case it is better to use another file as the entry file, because if you run `koa-cola build` or `koa-cola dev`, will override the file.

custom your own webpack entry file with store provided like:

```javascript
const store = ...
<Provider store={store} key="provider">
    <Router history={browserHistory}>
        <Route ... />
    </Router>
</Provider>
```

if you want to seamlessly use the store initialized by server side, you need to create store with the initial data by `window.__data` rendered by koa-cola:
```javascript
const { ReduxAsyncConnect, asyncConnect, reducer } = require('koa-cola/client');
// __data is the server side redux store serialization
const store = createStore(combineReducers(Object.assign({ reduxAsyncConnect: reducer }, ...custom_reducer))
    , (window as any).__data);
```

