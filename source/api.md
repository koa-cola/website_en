---
layout: default
id: api
title: api
next: api-controllers.html
---

folder `api` contain all business logic layer except views, so it contain [controller](/api-controllers.html) and [model](/api-models.html) of MVC architecture.

the api module of using cli `koa-cola new` command include：
* controllers
* models
* schemas
* responses

after the application is launched, these api modules will inject into `app` global, so that mean you can get these refer module by calling `app.modulename.xxx` like `app.controllers.IndexController`

there are other module that you can inject into app global if needed like：
* policies
* services
* managers
* middlewares


