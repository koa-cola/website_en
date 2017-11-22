---
layout: default
id: tip6-compile
title: Compiling
prev: tip5-debug.html
---


### Browser side
<!-- 前端的bundle build使用webpack来构建，使用cli命令创建项目，会自动生成[webpack配置](https://github.com/hcnode/koa-cola/blob/master/template/webpack.config.js)
ts文件的loader使用了[awesome-typescript-loader](https://github.com/s-panferov/awesome-typescript-loader)，并配置了使用babel，加入babel-polyfill到bundle，可以兼容ie9+。 -->
The front-end bundle is built by webpack. When using the cli command to create a koa-cola project, it will be automatically generated [webpack config](https://github.com/hcnode/koa-cola/blob/master/template/webpack.config.js)
We use [awesome-typescript-loader](https://github.com/s-panferov/awesome-typescript-loader) as ts loader, and babel, add `babel-polyfill` to bundle. 

<!-- webpack的入口tsx文件在项目里面的`view/app.tsx`: -->
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

<!-- wepack build 新建默认的项目得到的bundle的大小有400K，依赖的库组成如下图： -->
Run `webpack build` to build the default project, it will generate a bundle of size at about 400K. Dependent library composition as shown below:

<img src="https://github.com/hcnode/koa-cola/raw/master/screenshots/bundle.png" alt="Drawing" width="800"/>

<!-- webpack的配置文件默认加了四个IgnorePlugin插件，因为有些文件是前后端都会使用，所以需要忽略服务器端的require。 -->
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


<!-- ### Server side -->
<!-- koa-cola框架使用typescript编写，生产环境的代码是使用最新的js标准语法(需node7.6及以上)，即只编译代码的`import export`、ts语法，并未编译es6或es7（比如async/await），所以将不支持低版本的node。 -->
<!-- The koa-cola framework is writed by typescript. The code apply the latest js standard syntax (node7.6 and above) which released in production environment. compiler only transfer `import export` and ts syntax, not transferring es6 or es7 (e.g. async/await). So the lower version of node will not be supported. -->

<!-- 如需在低版本node的环境下使用，请您自己修改[typescript编译设置](https://www.typescriptlang.org/docs/handbook/compiler-options.html)，编译koa-cola框架的代码。 -->
<!-- If you want to use koa-cola in the lower version of node environment, please modify [Typescript Compiler Options](https://www.typescriptlang.org/docs/handbook/compiler-options.html) to compile koa-cola framework's code. -->

<!-- 如果在node.js 7.6及以上的环境下运行，则可以直接引用，用过ts-node运行（cli运行命令都是使用ts-node），甚至可以直接[线上使用](https://github.com/TypeStrong/ts-node/issues/104) -->
<!-- If the app is running in node.js environment of v7.6 or above, we can directly run it without any trouble. It's run by ts-node(cli command is using ts-node). 
Even we can [deployed it in production](https://github.com/TypeStrong/ts-node/issues/104). -->
