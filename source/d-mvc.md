---
layout: default
id: d-mvc
title: MVC pattern with decorator
prev: universal.html
next: installation.html
---

In koa-cola we can write mvc by using es7's decorator. Controller have to be defined with the provided decorator (as it relates to the router related definition), and the model and view layers are not forced to be defined by the decorator as the demo following.

### Controller
    
Use decorator to inject dependencies. In the router layer, the decorators include router, middleware, response and view. 
In the response phase, the decorators including koa.Context, param, response, request, etc. For example. The following example:

```javascript
const { 
    Controller, Get, Use, Param, Body, Delete, Put, Post, QueryParam, View, Ctx, Response 
} = require('koa-cola/client');
import Ok from '../responses/ok';

@Controller('') 
class FooController {
    @Get('/some_api')  // define router
    @Response(Ok)      // define return data format of API
    some_api (@Ctx() ctx, @QueryParam() param : any) { 
        // inject ctx & param
        // The data return the format defined by "Ok"
        return {
            foo : 'bar'
        }
    }

    @Get('/some_page') // define router
    @View('some_page') // this router use the page "some_page.tsx" inside "/views/pages/"  to render the view
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

Ok Response

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


### View

Page's view components can use different types of react components

* `React.Component` component
* stateless function component
* react-redux component
* `Cola` decorator component provided by koa-cola (React-redux based data initialization component).

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
Use Cola decorators to create react-redux base components.

If there's children components also created with `Cola` decorator, you need to use `include` decorator to include them:

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

When koa-cola render view in server side, it will be looking for `views/pages/layout.ts` as the page layout.
if `layout.ts` file does not exist, the view component will render directly.
If the view component uses the `doNotUseLayout` decorator, the page will not use `layout.ts`, and you probably need `header` and `bundle` decorators to define header and resource.

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
#### create "user.ts" directly under the directory "api/models"

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

First create schema `user.ts` in the `api/schemas` directory:

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

Create a model `user.ts` in `api/models`:

```javascript
import * as mongoose from 'mongoose'
import userSchema from '../schemas/user'
export default mongoose.model('user', new mongoose.Schema(userSchema(mongoose)))
```

Use decorator to define model also works well, we can define the relevant hook if needeed. More details can visit [mongoose-decorators](https://github.com/aksyonov/mongoose-decorators)

```javascript
import { todoListSchema } from '../schemas/todoList';
const { model } = app.decorators.model;

@model(todoListSchema(app.mongoose))
export default class TodoList {}
```

Generate model's schema using cli

`koa-cola schema` will automatically generate model interface in `typings/schema.ts`.

Then you can enjoy the convenience of vscode's intellisense by defining the types of typescript in your code.

```javascript
import {userSchema} from './typings/schema' 
const user : userSchema = await app.models.user.find({name : 'harry'})
```

As mentioned earlier, the reason we need to define the model schema in `api/schemas`, in addition to generate schema interface, you can use the schema in both browser and server side. more detail you can visit [document](http://mongoosejs.com/docs/browser.html)

#### koa-cola provides universal api interface definitions for both front and back end, such as `GetTodoList` api definition in the todolist demo:

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

Use api in the code, and get the convenience provided by ts:

```javascript
const api = new GetTodoList({});
const data = await api.fetch(helpers.ctx);
```

<img src="https://github.com/hcnode/koa-cola/raw/master/screenshots/api1.png" alt="Drawing" width="600"/>
<img src="https://github.com/hcnode/koa-cola/raw/master/screenshots/api2.png" alt="Drawing" width="600"/>


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
