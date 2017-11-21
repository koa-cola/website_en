---
layout: default
id: installation
title: Getting Started
prev: d-mvc.html
next: cli.html
---


<!-- koa-cola支持node.js的版本包括7.6和8，建议使用8，因为8.0使用的最新的v8版本，而且8.0会在[今年10月正式激活LTS](https://github.com/nodejs/LTS)，因为koa-cola的async/await是原生方式使用没有经过transform，所以不支持node7.6以下的node版本。 -->

## Create a project

* **install global koa-cola, ts-node, typescript**
`npm i koa-cola ts-node typescript -g` 

<!-- * **在当前文件夹创建名字为app的新koa-cola项目，创建完整的目录结构，并自动安装依赖** -->
* **Create a new koa-cola project in the current folder, name `app`. It will automatically create a complete directory structure, and install dependencies**
`koa-cola new app` 

* **dev的开发模式启动项目，生成 webpack bundle、启动项目、并自动打开浏览器，并自动watch源码，当源码有修改，bundle js和ssr服务器端渲染都会自动重新加载module**
* **Start the project as development model, generate webpack bundle, start the project, and automatically open the browser, and watch the code changes. When the source has been modified, bundled js and ssr server-side rendering will automatically reload module**
`cd koa-cola-app`
`koa-cola dev` 

Video demo：

<a href="http://www.koa-cola.com/doc/video/koa-cola-dev.mp4" target="_blank"><img src="http://www.koa-cola.com/doc/video/poster.png" width="500" /></a>

### Use the route decorator to create route, and return json data

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

### Use the route decorator to create route, and render with the React's pages components.

#### Render static components

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

#### Method to render components with data dependence (1)

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

#### Method to render components with data dependence (2)

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

