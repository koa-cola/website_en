---
layout: default
id: installation
title: 如何使用
prev: d-mvc.html
next: cli.html
---


<!-- koa-cola支持node.js的版本包括7.6和8，建议使用8，因为8.0使用的最新的v8版本，而且8.0会在[今年10月正式激活LTS](https://github.com/nodejs/LTS)，因为koa-cola的async/await是原生方式使用没有经过transform，所以不支持node7.6以下的node版本。 -->

## 创建项目

* **安装全局koa-cola, ts-node, typescript**
`npm i koa-cola ts-node typescript -g` 

* **在当前文件夹创建名字为app的新koa-cola项目，创建完整的目录结构，并自动安装依赖**
`koa-cola new app` 

* **dev的开发模式启动项目，生成 webpack bundle、启动项目、并自动打开浏览器，并自动watch源码，当源码有修改，bundle js和ssr服务器端渲染都会自动重新加载module**
`cd koa-cola-app`
`koa-cola dev` 

视频演示：

<a href="http://www.koa-cola.com/doc/video/koa-cola-dev.mp4" target="_blank"><img src="http://www.koa-cola.com/doc/video/poster.png" width="500" /></a>

### 使用路由装饰器创建路由，并返回json数据

`api/controllers/any_controller.ts`

```javascript
var { Controller, Get } = require('koa-cola/client');

@Controller('/api')
export default class  {
    @Get('/todo/list')
    list ( ) {
        return [
            'todo1', 'todo2'
        ]
    }
}
```

### 使用路由装饰器创建路由，并通过react page组件渲染

#### 渲染静态组件

`api/controllers/any_controller.ts`

```javascript
var { Controller, Get, View } = require('koa-cola/client');

@Controller('/')
export default class  {
    @Get('index')
    @View('index')
    index ( ) {}
}
```

`views/pages/index.tsx`
```javascript
import * as React from 'react';
export default function() {
    return <div>
        Wow koa-cola!
    </div>
};
```

#### 渲染数据依赖组件方法1

`api/controllers/any_controller.ts`

```javascript
var { Controller, Get, View } = require('koa-cola/client');

@Controller('/')
export default class  {
    @Get('index')
    @View('index')
    index async () {
        return {
            foo : await Promise.resolve('bar')
        }
    }
}
```

`views/pages/index.tsx`

```javascript
import * as React from 'react';
export default function({ctrl : {foo}}) {
    return <div>
        {foo}
    </div>
};
```

#### 渲染数据依赖组件方法2

`api/controllers/any_controller.ts`

```javascript
var { Controller, Get, View } = require('koa-cola/client');

@Controller('/')
export default class  {
    @Get('index')
    @View('index')
    index async () {}
}
```

`views/pages/index.tsx`

```javascript
import * as React from 'react';
var { Cola } = require('koa-cola/client')

@Cola({
    initData : {
        foo : async ({ params, helpers }) => {
            return await Promise.resolve('bar');
        }
    }
})
export default class Page extends React.Component<Props, States>   {
  constructor(props: Props) {
      super(props);
  }
  render() {
    return <div>
      <div>{this.props.foo}</div>
    </div>
  }
};
```

