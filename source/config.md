---
layout: default
id: config
title: config
prev: api-responses.html
next: config-env.html
---

## global.app.config

<!-- 通过约定`/config/`一级目录下所有的js文件都会成为 `app.config` 的属性，运行时会被 env 环境对应的`/config/env/`下的js配置覆盖。 -->

	> config
	    > env
            local.js
            test.js
            development.js
            production.js
        bootstrap.js
        middlewares.js
        model.js
        any_config_you_need.js 
        ...

比如配置 any_config_you_need.js 

```js
exports.module = {
  foo : 'bar'
}
```

那么`app.config.foo === 'bar'`

如果当前是development环境，并且 config/env/development.js 定义以下:

```js
exports.module = {
  foo : 'wow'
}
```

那么`any_config_you_need.js`的`foo`就会被覆盖：`app.config.foo === 'wow'`


## 默认配置

### config.middlewares

  自定 koa 中间件的开关。

  cola加载koa中间件时，会根据此配置进行中间件加载。假如没定义此配置，将直接使用默认的中间件。

  cola根据此配置，在`/api/middlewares/**`定义中间件里抽取加载。

  例如`/config/`下新增文件`myMiddleWares.js`, 添加以下代码：
  
  ```js
    module.exports = {
      middlewares: {
        "middleware1": true,
        "koa-static": false
      }
    };
  ```

  那么koa将加载`/api/middlewares/middleware1.js`中间件，以及cola默认的中间件, 但会把默认加入的`koa-static`中间件去除。