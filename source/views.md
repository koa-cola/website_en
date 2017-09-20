---
layout: default
id: views
title: views
prev: config/env.html
next: views-pages.html
---

views目录是mvc的view层目录，也是放置react组件的目录，在koa-cola react组件分两种：一种是[页面](/doc/views-pages.html)，在views/pages下，另一种是[组件](/doc/views-components.html)，在views/components下。

views目录下的[app.tsx](/doc/views-app.html)是整个app的bundle入口文件。

views/pages/layout.ts是page最终在服务器端渲染的时候生成的html输入模板，如果没有此文件，则直接输入页面组件的html。

