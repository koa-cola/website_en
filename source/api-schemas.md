---
layout: default
id: api-schemas
title: schemas
prev: api-models.html
next: api-responses.html
---

It's inevitable to define the data schema whether it is using mongodb or other databases. 
It's a benefit to make server-side and frontend to reuse the same code.

After starting the app, server side can use `app.schemas` to get schema object, front side can get it through `require` files.