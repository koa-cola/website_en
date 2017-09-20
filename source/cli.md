---
layout: default
id: cli
title: Cli命令
prev: installation.html
---

koa-cola提供了一些有用的cli命令，包括新建项目、启动项目、生成model schema文件

### 创建koa-cola项目

`koa-cola new app` 或者 `koa-cola n app` 在当前目录创建文件夹名字为app的模版项目，并自动安装依赖，和自动build bundle和启动应用。

### 启动应用

`koa-cola` 在项目目录里面执行，启动项目，node端启动app项目，但是不会build bundle

`koa-cola dev` dev模式启动，build webpack bundle、launch项目、并自动打开浏览器

### build bundle

`koa-cola build` 执行build命令，会自动寻找controller，并通过controller找到view，最后生成Provider，这个Provider会是webapck build js bundle的入口。

**注意：这将会覆盖你的view/app.tsx**

如果你需要维护你的app.tsx，那么你需要运行webpack命令而不是`koa-cola build`

### 生成model schema文件

`koa-cola schema` 或者 `koa-cola s` 生成`api/schenmas`下面的model schema定义，保存在`typings/schema.ts`

