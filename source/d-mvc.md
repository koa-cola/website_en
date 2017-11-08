---
layout: default
id: d-mvc
title: MVC pattern with decorator
prev: universal.html
next: installation.html
---

<!-- koa-cola可以使用es7的decorator装饰器开发模式来写mvc，controller是必须用提供的decorator来开发（因为涉及到router相关的定义），model和view层则没有强制需要demo所演示的decorator来开发。 -->
Using koa-cola we can write mvc using es7's decorator development mode. Controller must be developed with the provided decorator (as it relates to the router-related definition), and the model and view layers are not forced to be developed by the decorator as the demo following.

### Controller
    
<!-- 使用decorator装饰器来注入相关依赖，路由层的decorators包括router、中间件、response、view，响应阶段的decorators包括koa.Context、param、response、request等，比如以下例子： -->
Use decorator to inject dependencies. In the routing layer, the decorators include router, middleware, response and view. 
In the response phase, the decorators including koa.Context, param, response, request, etc. For example. The following example:

```javascript
const { 
    Controller, Get, Use, Param, Body, Delete, Put, Post, QueryParam, View, Ctx, Response 
} = require('koa-cola/client');
import Ok from '../responses/ok';

@Controller('') 
class FooController {
    @Get('/some_api')  // define router & method
    @Response(Ok)      // define data structure of API
    some_api (@Ctx() ctx, @QueryParam() param : any) { // inject ctx & param
        // Initialize the data. The data will be returned in the format defined by "Ok"
        return {
            foo : 'bar'
        }
    }

    // define router & method
    @Get('/some_page')  
    // This represents that has a page named "some_page.tsx" inside "/views/pages/" 
    @View('some_page')  
    some_page (@Ctx() ctx, @QueryParam() param : any) { // inject ctx & param
        // Initialize the data.
        // Data will be injected into react component's props, 
        // we can call that data by: "this.props.ctrl.foo"
        return {
            foo : 'bar'
        }
    }
}
```

Ok module：

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

<!-- 因为使用decorator定义router，所以在koa-cola里面不需要单独定义router。 -->
Because router is defined using decorator, there is no need to define router separately in koa-cola.

### View

<!-- page的view组件可以使用不同类型的react组件： -->
Page's view components can use different types of react components

* `React.Component` component
* stateless function component
* react-redux component
* `Cola` decorator component provided by koa-cola (React-redux-based data initialization component).

#### React.Component

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

#### stateless component

```javascript
    export default function({some_props}) {
        return <h1>Wow koa-cola!</h1>
    }
```

#### react-redux component

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

#### Cola decorator component
<!-- 使用Cola装饰器来封装基于react-redux的组件 -->
Use Cola decorators to package react-redux-based components.

<!-- 如果有子组件也是使用Cola 装饰器封装，则需要使用装饰器`include` -->
If you have sub-components also package with `Cola` decorator, you need to use `include` decorator:

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

#### Custom header & bundle packing

<!-- koa-cola 渲染页面时，默认会找`views/pages/layout.ts`封装页面的 html，如果没有这个`layout`文件，则直接输出 page 组件返回的 html，如果 view 组件使用了`doNotUseLayout` 装饰器，则页面不会使用`layout.ts`输出，这时你可以自定义`header`和`bundle`装饰器。 -->
When koa-cola render page, it will find `views/pages/layout.ts` to package the html by default.
Without this `layout.ts` file, the html will display the output of the view component directly.
If the view component uses the `doNotUseLayout` decorator, the page will not use `layout.ts`, and you can customize `header` and `bundle` decorators.

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
<!-- `controller`层、react 组件的`view`层必须使用 decorator，而`model`层则没有这个限制，它完全没有耦合。您可以使用 koa-cola 风格来编写 model，以获得更一致的开发体验，也可以随意使用任何 orm 或者 odm，或者不需要 model 层也可以。 -->
we must use decorator at `controller` layer and react component's `view` layer. Whereas the `model` layer does not have this limitation, it has no coupling at all. You can write models using the koa-cola style for a more consistent development experience, as you can freely use any orm or odm, or do not need any model layer.

<!-- #### 你可以直接在目录 api/models 下创建如 user.ts： -->
#### You can create "user.ts" directly under the directory "api/models"

```javascript
import * as mongoose from 'mongoose'
export default mongoose.model('user', new mongoose.Schema({
    name : String,
    email : String
}))
```

Then you can use it in other code:
```javascript
const user = await app.models.user.find({name : 'harry'})
```

#### koa-cola style to write the model

<!-- 首先在`api/schemas`目录创建`user.ts` -->
First create `user.ts` in the `api/schemas` directory:

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

<!-- 在目录`api/models`下创建 model 如`user.ts`： -->
Create a model in the directory `api/models`, such as `user.ts`:

```javascript
import * as mongoose from 'mongoose'
import userSchema from '../schemas/user'
export default mongoose.model('user', new mongoose.Schema(userSchema(mongoose)))
```

<!-- 当然也可以使用 decorator 方式定义 model，还可以定义相关hook，详情可以参考[mongoose-decorators](https://github.com/aksyonov/mongoose-decorators) -->
Use decorator to define model is also works well, we can also define the relevant hook. More details can refer to [mongoose-decorators](https://github.com/aksyonov/mongoose-decorators)

```javascript
import { todoListSchema } from '../schemas/todoList';
const { model } = app.decorators.model;

@model(todoListSchema(app.mongoose))
export default class TodoList {}
```

<!-- 使用 cli 生成 model 的 schema -->
Generate model's schema using cli

<!-- `koa-cola --schema` 自动生成model的接口定义在`typings/schema.ts` -->
`koa-cola --schema` will automatically generate model interface, definition release at `typings/schema.ts`.

<!-- 然后你可以在代码通过使用 typescript 的类型定义，享受 vscode 的 intellisense 带来的便捷 -->
Then you can enjoy the convenience of vscode's intellisense by defining the types of typescripts in your code.

```javascript
import {userSchema} from './typings/schema' 
const user : userSchema = await app.models.user.find({name : 'harry'})
```

<!-- 在前面提到的为何需要在`api/schemas`定义 model 的 schema，除了上面的自动生成 schema 接口，还可以在浏览器端代码复用，比如数据Validate。详细可以查看[文档](http://mongoosejs.com/docs/browser.html) -->
As mentioned earlier, the reason we need to define the model schema in `api/schemas`, in addition to automatically generated schema interface above, but also reusing in the browser-side, such as data Validate. Detailed can view [document](http://mongoosejs.com/docs/browser.html)

<!-- #### koa-cola提供了前后端universal的api接口定义，比如todolist demo的获取数据的接口定义 -->
#### koa-cola provides universal api interface definitions for front and back ends, such as `GetTodoList` interface definition in the todolist demo.

```javascript
import { todoListSchema } from './typings/schema';
import { ApiBase, apiFetch } from 'koa-cola';

export class GetTodoList extends ApiBase<
  {
      // Parameter Type
  },
  {
    code: number;
    result: [todoListSchema];
  },
  {
      // Abnormal definition
  }
> {
  constructor(body) {
    super(body);
  }
  url: string = '/api/getTodoList';
  method: string = 'get';
}
```

<!-- 在代码里面使用 api，并享受 ts 带来的便捷： -->
Use api in the code, and get the convenience provided by ts:

```javascript
const api = new GetTodoList({});
const data = await api.fetch(helpers.ctx);
```

<img src="https://github.com/hcnode/koa-cola/raw/master/screenshots/api1.png" alt="Drawing" width="600"/>
<img src="https://github.com/hcnode/koa-cola/raw/master/screenshots/api2.png" alt="Drawing" width="600"/>

<!-- 又比如参数`body`的定义，如果定义了必传参数，调用时候没有传，则 vscode 会提示错误 -->
One more example is the definition of the parameter `body`. If the parameters must be passed, the transfer is not passed, vscode will prompt an error.

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
