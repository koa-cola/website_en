---
layout: default
id: tip6-compile
title: 代码编译
prev: tip5-debug.html
---


### 浏览器端
前端的bundle build使用webpack来构建，使用cli命令创建项目，会自动生成[webpack配置](https://github.com/hcnode/koa-cola/blob/master/template/webpack.config.js)
ts文件的loader使用了[awesome-typescript-loader](https://github.com/s-panferov/awesome-typescript-loader)，并配置了使用babel，加入babel-polyfill到bundle，可以兼容ie9+。

webpack的入口tsx文件在项目里面的`view/app.tsx`:
```javascript
import * as React from 'react';
import { render } from 'react-dom';

import IndexController from '../api/controllers/IndexController';
// 以下是3个view(react component)的入口。
import index from './pages/index';
import officialDemo from './pages/officialDemo';
import colastyleDemo from './pages/colastyleDemo';

const { createProvider } = require('koa-cola');
// 使用koa-cola提供的createProvider会自动建立路由，如果手动使用官方的Provider，则需要开发者手动写router
const Provider = createProvider([IndexController], {
  index,
  officialDemo,
  colastyleDemo
});

render(<Provider />, document.getElementById('app'));
```

wepack build 新建默认的项目得到的bundle的大小有400K，依赖的库组成如下图：
<img src="https://github.com/hcnode/koa-cola/raw/master/screenshots/bundle.png" alt="Drawing" width="800"/>

webpack的配置文件默认加了四个IgnorePlugin插件，因为有些文件是前后端都会使用，所以需要忽略服务器端的require。

```javascript
// 以下两个是给服务器端使用，不能打包到webpack
new webpack.IgnorePlugin(/\.\/src\/app/),
new webpack.IgnorePlugin(/\.\/src\/util\/injectGlobal/),
// 以下两个是controller引用的，也是服务器端使用，也不能打包到webpack，如果你的controller也有服务器端使用的库，也必须要加IgnorePlugin插件
new webpack.IgnorePlugin(/koa$/),
new webpack.IgnorePlugin(/koa-body$/),
```


### 服务器端
koa-cola框架使用typescript编写，生产环境的代码是使用最新的js标准语法(需node7.6及以上)，即只编译代码的`import export`、ts语法，并未编译es6或es7（比如async/await），所以将不支持低版本的node。

如需在低版本node的环境下使用，请您自己修改[typescript编译设置](https://www.typescriptlang.org/docs/handbook/compiler-options.html)，编译koa-cola框架的代码。

如果在node.js 7.6及以上的环境下运行，则可以直接引用，用过ts-node运行（cli运行命令都是使用ts-node），甚至可以直接[线上使用](https://github.com/TypeStrong/ts-node/issues/104)
