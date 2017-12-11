---
layout: default
id: cli
title: Cli commander
prev: installation.html
---

koa-cola provides some useful cli commands, include creating a new project, launching a project, and generating a model schema file.

### Create a koa-cola project

new koa-cola project:

```shell
koa-cola new app
```
 or 
```shell
koa-cola n app
```
the project will install dependencies, build bundle, and launch the app automatically.

### launch App

To launch the project:
 ```shell
 koa-cola
 ```

To start as development mode, build webpack bundle, launch project, and watch files automatically:
```shell
koa-cola dev
```

### build bundle

To run a build command:
```shell
koa-cola build
```
the build action will find the controllers, and through which to find the views, finally create Provider of redux by these views and reducer of them. This Provider is the entry of the webapck build js bundle.

**Note: This will overwrite your `view/app.tsx`**

If you want a 'homemade' `app.tsx` , you need to run the `webpack` command instead of `koa-cola build`.

### Create model schema file

Run `koa-cola schema` or `koa-cola s` to create definition of model schema inside `api/schenmas`. 
file will save as `typings/schema.ts`.

