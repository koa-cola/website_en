---
layout: default
id: tip6-compile
title: Compiling
prev: tip5-debug.html
---


### Browser side
<!-- 前端的bundle build使用webpack来构建，使用cli命令创建项目，会自动生成[webpack配置](https://github.com/hcnode/koa-cola/blob/master/template/webpack.config.js)ts文件的loader使用了[awesome-typescript-loader](https://github.com/s-panferov/awesome-typescript-loader)，并配置了使用babel，加入babel-polyfill到bundle，可以兼容ie9+。 -->
The front-end bundle is builded by webpack. When using the cli command to create a project, it will be automatically generated [webpack config](https://github.com/hcnode/koa-cola/blob/master/template/webpack.config.js)
We used [awesome-typescript-loader](https://github.com/s-panferov/awesome-typescript-loader) as ts loader, and has config babel, add `babel-polyfill` to bundle. it will support ie9+.

The entry of webpack is `view/app.tsx` in the project by default.

```javascript
import * as React from 'react';
import { render } from 'react-dom';

import IndexController from '../api/controllers/IndexController';
// The following 3 modules are the entrance of react components.
import index from './pages/index';
import officialDemo from './pages/officialDemo';
import colastyleDemo from './pages/colastyleDemo';

const { createProvider } = require('koa-cola');
// using createProvider provided by koa-cola will automatically create router，
// If want to the official Provider, we will need to write router by ourselves
const Provider = createProvider([IndexController], {
  index,
  officialDemo,
  colastyleDemo
});

render(<Provider />, document.getElementById('app'));
```

Run `webpack build` to build the default project, it will generate a bundle of size at about 400K. Dependent library composition as shown below:

<img src="https://github.com/hcnode/koa-cola/raw/master/screenshots/bundle.png" alt="Drawing" width="800"/>

The webpack configuration file has four IgnorePlugin plugins by default, because some files are required at both front and server side, so we need to ignore the server-side requires.

```javascript
// The following two are for server-side use, no need package into webpack
new webpack.IgnorePlugin(/\.\/src\/app/),
new webpack.IgnorePlugin(/\.\/src\/util\/injectGlobal/),
// The following two are controller references, used on the server-side, so must be ignored by webpack. 
// If your controller also has a server-side library, you must also add IgnorePlugin plug-in.
new webpack.IgnorePlugin(/koa$/),
new webpack.IgnorePlugin(/koa-body$/),
```

