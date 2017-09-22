---
layout: default
id: d-mvc
title: decorator的mvc开发模式
prev: universal.html
next: installation.html
---

koa-cola可以使用es7的decorator装饰器开发模式来写mvc，controller是必须用提供的decorator来开发（因为涉及到router相关的定义），model和view层则没有强制需要demo所演示的decorator来开发。
### Controller
    
使用decorator装饰器来注入相关依赖，路由层的decorators包括router、中间件、response、view，响应阶段的decorators包括koa.Context、param、response、request等，比如以下例子：

```javascript
const { 
    Controller, Get, Use, Param, Body, Delete, Put, Post, QueryParam, View, Ctx, Response 
} = require('koa-cola/client');
import Ok from '../responses/ok';

@Controller('') 
class FooController {
    @Get('/some_api')  // 定义 router 以及 method
    @Response(Ok)      // 定义 API 返回的数据结构
    some_api (@Ctx() ctx, @QueryParam() param : any) { // 注入 ctx 和 param
        // 初始化数据，数据将会以 “Ok” 定义的格式返回
        return {
            foo : 'bar'
        }
    }

    @Get('/some_page')  // 定义 router 以及 method
    @View('some_page')  // 在 /views/pages/ 下有对应的 some_page.tsx 页面
    some_page (@Ctx() ctx, @QueryParam() param : any) { // 注入ctx和param
        // 初始化数据，数据将会注入到react组件的props，如：this.props.ctrl.foo
        return {
            foo : 'bar'
        }
    }
}
```
Ok 模块：
```javascript
import * as Koa from 'koa';
export default function Ok(ctx : Koa.Context, data){
    ctx.status = 200;
    if(data){
        ctx.body = {
            code : 200,
            result : data
        };
    }
}
```

因为使用decorator定义router，所以在koa-cola里面不需要单独定义router。

### View

view 层可以是简单的`React.Component`或者是 stateless 的函数组件，也可以是使用 react-redux 封装过的组件，[todolist demo](https://github.com/koa-cola/todolist) 的 view 则使用了[redux-connect](https://github.com/makeomatic/redux-connect) 提供的 decorator (当然你也可以直接用它的 connect 方法)，redux-connect 也是基于 react-redux，以下是 view 层支持的 react 组件类型。
    
#### React.Component组件

```javascript
    class Index extends React.Component<Props, States>   {
        constructor(props: Props) {
            super(props);
        }
        static defaultProps = {
            
        };
        render() {
            return <h1>Wow koa-cola!</h1>
        }
    };
    export default Index
```

#### stateless组件

```javascript
    export default function({some_props}) {
        return <h1>Wow koa-cola!</h1>
    }
```

#### react-redux组件

```javascript
    import { connect } from 'react-redux'
    const Index = function({some_props}) {
        return <h1>Wow koa-cola!</h1>
    }
    export default connect(
        mapStateToProps,
        mapDispatchToProps
    )(Index)
```

#### Cola 装饰器组件
使用Cola装饰器来封装基于react-redux的组件

如果有子组件也是使用`redux-connect`封装，则需要使用装饰器`include`

可以参考 todolist 的 [colastyleDemo代码](https://github.com/koa-cola/todolist/blob/25e4e3420f656de4aeab064e3a254b056a834003/views/pages/colastyleDemo.tsx#L45)

```javascript
import AddTodo from '../official-demo/containers/AddTodo';
import FilterLink from '../official-demo/containers/FilterLink';
import VisibleTodoList from '../official-demo/containers/VisibleTodoList';
const {
  Cola
  include
} = require('koa-cola/client');
@Cola({
    initData : {
        todosData : async ({ params, helpers, store: { dispatch } }) => {
            const api = new GetTodoList({});
            const data = await api.fetch(helpers.ctx);
            dispatch({
                type: 'INIT_TODO',
                data: data.result.result
            });
            return data.result.result;
        }
    },
    reducer : {
        todos,
        visibilityFilter
    }
})
@include({ AddTodo, FilterLink, VisibleTodoList })
class ColastyleDemo extends React.Component<Props, States> {
  constructor(props: Props) {
    super(props);
  }
  render() {
    return <App />;
  }
}
export default ColastyleDemo;
```

#### 自定义 header 和 bundle 方式

koa-cola 渲染页面时，默认会找`views/pages/layout.ts`封装页面的 html，如果没有这个`layout`文件，则直接输出 page 组件返回的 html，如果 view 组件使用了`doNotUseLayout` decorator，则页面不会使用`layout.ts`输出，这时你可以自定义`header`和`bundle`的 decorator。

```javascript
import * as React from 'react';
const {
  header, bundle, doNotUseLayout
} = require('koa-cola/client');
@doNotUseLayout
@bundle([
  "/bundle.js",
  "/test.js"
])
@header(() => {
  return <head>
    <meta name="viewport" content="width=device-width" />
  </head>
})
function Page (){
  return <h1>koa-cola</h1>
};
export default Page
```

### Model
`controller`层、react 组件的`view`层必须使用 decorator，而`model`层则没有这个限制，它完全没有耦合。您可以使用 koa-cola 风格来编写 model，以获得更一致的开发体验，也可以随意使用任何 orm 或者 odm，或者不需要 model 层也可以。

#### 你可以直接在目录 api/models 下创建如 user.ts：
```javascript
import * as mongoose from 'mongoose'
export default mongoose.model('user', new mongoose.Schema({
    name : String,
    email : String
}))
```

然后就可以在其他代码里面使用：
```javascript
const user = await app.models.user.find({name : 'harry'})
```

#### 使用 koa-cola 的风格写 model

首先在`api/schemas`目录创建`user.ts`

```javascript
export const userSchema = function(mongoose){
    return {
        name: {
            type : String
        },
        email : {
            type : String
        }
    }
}
```

在目录`api/models`下创建 model 如`user.ts`：
```javascript
import * as mongoose from 'mongoose'
import userSchema from '../schemas/user'
export default mongoose.model('user', new mongoose.Schema(userSchema(mongoose)))
```

当然也可以使用 decorator 方式定义 model，还可以定义相关hook，详情可以参考[mongoose-decorators](https://github.com/aksyonov/mongoose-decorators)

```javascript
import { todoListSchema } from '../schemas/todoList';
const { model } = app.decorators.model;

@model(todoListSchema(app.mongoose))
export default class TodoList {}
```

使用 cli 生成 model 的 schema

`koa-cola --schema` 自动生成model的接口定义在`typings/schema.ts`

然后你可以在代码通过使用 typescript 的类型定义，享受 vscode 的 intellisense 带来的便捷
```javascript
import {userSchema} from './typings/schema' 
const user : userSchema = await app.models.user.find({name : 'harry'})
```

在前面提到的为何需要在`api/schemas`定义 model 的 schema，除了上面的自动生成 schema 接口，还可以在浏览器端代码复用，比如数据Validate。详细可以查看[文档](http://mongoosejs.com/docs/browser.html)

#### koa-cola提供了前后端universal的api接口定义，比如todolist demo的获取数据的接口定义

```javascript
import { todoListSchema } from './typings/schema';
import { ApiBase, apiFetch } from 'koa-cola';

export class GetTodoList extends ApiBase<
  {
      // 参数类型
  },
  {
    code: number;
    result: [todoListSchema];
  },
  {
      // 异常定义
  }
> {
  constructor(body) {
    super(body);
  }
  url: string = '/api/getTodoList';
  method: string = 'get';
}
```

在代码里面使用 api，并享受 ts 带来的便捷：
```javascript
const api = new GetTodoList({});
const data = await api.fetch(helpers.ctx);
```

<img src="https://github.com/hcnode/koa-cola/raw/master/screenshots/api1.png" alt="Drawing" width="600"/>
<img src="https://github.com/hcnode/koa-cola/raw/master/screenshots/api2.png" alt="Drawing" width="600"/>

又比如参数`body`的定义，如果定义了必传参数，调用时候没有传，则 vscode 会提示错误
```javascript
import { testSchema } from './typings/schema';
import { ApiBase, apiFetch } from 'koa-cola'
export interface ComposeBody{
    foo : string,
    bar? : number
}
export class Compose extends ApiBase<ComposeBody, testSchema, {}>{
    constructor(body : ComposeBody){
        super(body)
    }
    url : string = '/compose'
    method : string = 'post'
}
```
<img src="https://github.com/hcnode/koa-cola/raw/master/screenshots/api3.png" alt="Drawing" width="600"/>
