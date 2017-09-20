---
layout: default
id: api
title: api
next: api-controllers.html
---

api目录包含应用的大部分业务逻辑，包括MVC架构中的[controller](/doc/api-controllers.html)和[和model](/doc/api-models.html)。

使用new命令创建出来的脚手架目录里面，api包括：
* controllers
* models
* schemas
* responses

在项目运行时，会将api的这些目录注入到全局app里面，如`app.controllers.IndexController`，可以在需要的时候使用。

注入到app的api目录还包括这些：
* policies
* services
* managers
* middlewares

以上这些目录不会出现在默认的项目里面，如果用户创建了，则会注入到app。
