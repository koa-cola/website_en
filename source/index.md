---
layout: default
id: index
title: What is koa-cola?
next: ssr.html
---

<!-- koa-cola是一个基于koa和react的服务器端SSR(server side render)和浏览器端的SPA(single page application)的web前后端全栈应用框架。 -->
koa-cola is a full stack web framework for Node.js, server side is base on koa and react server side render, and SPA(single page application) of client side.

<!-- koa-cola使用typescript开发，使用d-mvc（es7 decorator风格的mvc）开发模式。另外koa-cola大量使用universal ("isomorphic") 开发模式，比如react技术栈完全前后端universal（server端和client端均可以使用同一套component、react-redux、react-router）。 -->
koa-cola is developed by typescript, with d-mvc(es7 decorator style mvc) pattern. In addition, koa-cola stick with universal("isomorphic") develop mode, like react universal component, which both server and client side use the same component/react-redux/react-router.

<!-- koa-cola的开发风格受[sails](http://sailsjs.com/)影响，之前使用过sails开发过大型的web应用，深受其[约定优先配置](https://en.wikipedia.org/wiki/Convention_over_configuration)的开发模式影响。 -->
The develop style of koa-cola is inspired by[sails](http://sailsjs.com/). especially the [convention over configuration](https://en.wikipedia.org/wiki/Convention_over_configuration) develop mode.

<!-- * SSR+SPA的完整方案，只需要一份react代码便可以实现：服务器端渲染＋浏览器端bundle实现的交互 -->
* SSR + SPA solution: the same react code run in both server side and client side.
<!-- * 使用koa作为web服务（使用node8可以使用最新的v8高性能原生使用async/await） -->
* Using Koa as the web server, with node8.x or above we can use `async/await` natively and highly performance.
<!-- * 使用typescript开发 -->
* Coding with typescript.
<!-- * 使用完整的react技术栈(包括react-router和react-redux) -->
* Use full react tech stack (include react-router and react-redux).
<!-- * react相关代码前后端复用(包括component渲染、react-router和react-redux) -->
* Isomorphic JavaScript with react (include component reader, react-router and react-redux)