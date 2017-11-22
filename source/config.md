---
layout: default
id: config
title: config
prev: api-responses.html
next: config-env.html
---

## global.app.config

<<<<<<< HEAD
The app.config object contains the runtime values of your app's configuration. It is assembled automatically when koa-cola project is launched; merging together environment variables, and the configuration objects exported from any and all modules in your app's config/ directory.
=======
<!-- 通过约定`/config/`一级目录下所有的js文件都会成为 `app.config` 的属性，运行时会被 env 环境对应的`/config/env/`下的js配置覆盖。 -->
According to the convention, all the js files inside the top directory's `/config/` will become the property of `app.config`. 
And at the runtime, the folder `/config/[env]/` corresponding to the `env` setting will have a higher level than `/config/` to cover `app.config`.
>>>>>>> bc0399daf7e040375965137d33eccedf8be37c62

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

<<<<<<< HEAD
take any_config_you_need.js for example:
=======
For example: config `any_config_you_need.js`
>>>>>>> bc0399daf7e040375965137d33eccedf8be37c62

```js
exports.module = {
  foo : 'bar'
}
```

<<<<<<< HEAD
so `app.config.foo === 'bar'`

if environment NODE_ENV is 'development' and config/env/development.js contains:
=======
then `app.config.foo === 'bar'`

<!-- 如果当前是development环境，并且 config/env/development.js 定义以下: -->
If the current env is `development`, and we have a config of `config/env/development.js` like this:
>>>>>>> bc0399daf7e040375965137d33eccedf8be37c62

```js
exports.module = {
  ...
  foo : 'wow'
  ...
}
```

<<<<<<< HEAD
then app.config.foo will be override and will be `app.config.foo === 'wow'`

=======
and the `foo` that set by `any_config_you_need.js` will be covered: `app.config.foo === 'wow'`


## Default config

### config.middlewares

  Custom the switch of koa middleware.
  

  When cola load koa middleware, which middleware will be loaded based on this configuration. 
  If not defining this configuration, the default middleware will be used directly.

  <!-- cola根据此配置，在`/api/middlewares/**`定义中间件里抽取加载。 -->
  Cola will find the middleware inside `/api/middlewares/**` according to the config.

  <!-- 例如`/config/`下新增文件`myMiddleWares.js`, 添加以下代码： -->
  For example, we create a file name `myMiddleWares.js` in the `/config/`, with the following code:
  
  ```js
    module.exports = {
      middlewares: {
        "middleware1": true,
        "koa-static": false
      }
    };
  ```

  <!-- 那么koa将加载`/api/middlewares/middleware1.js`中间件，以及cola默认的中间件, 但会把默认加入的`koa-static`中间件去除。 -->
  Then Koa will load the middleware `/api/middlewares/middleware1.js`, and also the default Cola middleware except the `koa-static`.
>>>>>>> bc0399daf7e040375965137d33eccedf8be37c62
