---
layout: default
id: api-schemas
title: schemas
prev: api-models.html
next: api-responses.html
---

<!-- 无论是使用mongodb还是其他数据库，不可避免需要定义数据的schema，使用单独定义schema的方式，好处是可以前后端都可以使用。 -->
It's inevitable to define the data schema whether it is using mongodb or other databases. 
It's a benefit to make server-side and frontend to reuse the same file if we let schema be declared separately.

<!-- 启动app后服务器端就可以使用app.schemas的方式获取schema对象，浏览器端则可以直接使用require获取schema对象。 -->
After starting the app, server side can use `app.schemas` to get schema object, front side can get it through `require`.