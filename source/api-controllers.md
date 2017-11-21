---
layout: default
id: api-controllers
title: controllers
next: api-models.html
---

controller类保存的目录，controller类必须是基于`require('koa-cola/client')`的装饰器（decorator），使用装饰器可以定义路由router和view等信息，你可以根据不同的业务需求设计不同的controller。

The controller directory holds the `controller` class.
The `controller` class must be based on the `require('koa-cola/client')` decorator.
Using decorators, we can define the router and view. We can design different controllers according to different production needs.

## Controller that provides api interface

```javascript
const { Controller, Get, Post, Body, Ctx,  Response } = require('koa-cola/client');

@Controller('')
export default class {
  @Get('/todo/list')
  async getTodoList() {
    return await app.models.todo.find({});
  }

  
  @Post('/todo/save')
  async saveTodo(@Body() body) {
    return await app.models.todo.save(body);
  }
}
```

## Controller in the page's view
```javascript
const { Controller, Get, Post, Body, Ctx,  Response } = require('koa-cola/client');

@Controller('')
export default class {
  @Get('/index')
  async index() {
    return {
        list : await app.models.todo.find({})
    }
  }
}
```

index's page class (inside `views/pages` directory)

```javascript
import * as React from 'react';
function Index({ctrl : {list}}){
  return <div>
    <ul>
      {
          list.map(item => <li>{item.name}</li>)
      }
    </ul>
  </div>
}
```

koa-cola has provided some nice decorations.

<!-- ### 可以通过Response装饰器返回固定数据格式 -->
### Return fixed data format through the Response decorator

```javascript
  /**
  data format:
  [todoItem, ...]
  */
  @Get('/todo/list')
  async getTodoList() {
    return await app.models.todo.find({});
  }
```

Using Response decorator
```javascript
  const Ok = function Ok(ctx, data){
      ctx.status = 200;
      if(data){
          ctx.body = {
              code : 200,
              result : data
          };
      }
  }
  /**
  return data format:
  {
      code : 200,
      result : [todoItem, ...]
  }
  */
  @Get('/todo/list')
  @Response(Ok)
  async getTodoList() {
    return await app.models.todo.find({});
  }
```

### Using `Use` decorator to verify request

```javascript
 function isLogin(ctx, next){
    if(ctx.state.user){
        await next();
    }else{
        ctx.throw(401);
    }
}

...
  // Verify that the user is logged in, and return 401 if not
  @Get('/todo/list')
  @Response(Ok)
  @Use(isLogin)
  async getTodoList() {
    return await app.models.todo.find({});
  }
...
```