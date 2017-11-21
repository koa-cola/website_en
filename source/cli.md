---
layout: default
id: cli
title: Cli commander
prev: installation.html
---

<!-- koa-cola提供了一些有用的cli命令，包括新建项目、启动项目、生成model schema文件 -->
koa-cola provides some useful cli commands, include creating a new project, launching a project, and generating a model schema file.

### Create a koa-cola project

We can create a template project with the folder named `app` in the current directory by running:

```shell
koa-cola new app
```
 or 
 ```shell
koa-cola n app
```
after it finish, the project will automatically install dependencies, build bundle, and launch the app.

### launch App

<!-- `koa-cola` 在项目目录里面执行，启动项目，node端启动app项目，但是不会build bundle -->
To start the project, we enter the project directory and run:
 ```shell
 koa-cola
 ```
Then the node side will start app project, but will not build the frontend bundle.

To start as development mode, build webpack bundle, launch project, and open browser automatically:
```shell
koa-cola dev
```

### build bundle

To run a build command:
```shell
koa-cola build
```
 the build action will automatically find the controller, and through it to find the view, finilly release Provider.
 This Provider is the entry of the webapck build js bundle.

**Note: This will overwrite your `view/app.tsx`**

<!-- 如果你需要维护你的app.tsx，那么你需要运行webpack命令而不是`koa-cola build` -->
If we want to maintain the `app.tsx`, we need to run the `webpack` command instead of `koa-cola build`.

### Create model schema file

Run `koa-cola schema` or `koa-cola s` to create definition of model schema inside `api/schenmas`. 
file will save as `typings/schema.ts`.

