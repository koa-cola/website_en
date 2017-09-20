---
layout: default
id: installation
title: 如何使用
prev: d-mvc.html
next: cli.html
---


koa-cola支持node.js的版本包括7.6和8，建议使用8，因为8.0使用的最新的v8版本，而且8.0会在[今年10月正式激活LTS](https://github.com/nodejs/LTS)，因为koa-cola的async/await是原生方式使用没有经过transform，所以不支持node7.6以下的node版本。

* `npm i koa-cola ts-node -g` 安装全局koa-cola和ts-node
* `koa-cola new koa-cola-app` 在当前文件夹创建名字为app的新koa-cola项目，创建完整的目录结构，并自动安装依赖
* `cd koa-cola-app`
* `koa-cola dev` dev模式启动，build webpack bundle、launch项目、并自动打开浏览器

视频演示：

<a href="http://www.koa-cola.com/doc/video/koa-cola-dev.mp4" target="_blank"><img src="http://www.koa-cola.com/doc/video/poster.png" width="500" /></a>


