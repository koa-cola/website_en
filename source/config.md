---
layout: default
id: config
title: config
prev: api-responses.html
next: config-env.html
---

## global.app.config

The app.config object contains the runtime values of your app's configuration. It is assembled automatically when koa-cola project is launched; merging together environment variables, and the configuration objects exported from any and all modules in your app's config/ directory.

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

take any_config_you_need.js for example:

```js
exports.module = {
  foo : 'bar'
}
```

so `app.config.foo === 'bar'`

if environment NODE_ENV is 'development' and config/env/development.js contains:

```js
exports.module = {
  ...
  foo : 'wow'
  ...
}
```

then app.config.foo will be override and will be `app.config.foo === 'wow'`

