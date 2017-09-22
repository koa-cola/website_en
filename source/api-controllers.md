---
layout: default
id: api-controllers
title: controllers
next: api-models.html
---

controller类保存的目录，controller类必须是基于`require('koa-cola/client')`的装饰器（decorator），使用装饰器可以定义路由router和view等信息，你可以根据不同的业务需求设计不同的controller。

## 提供api接口的controller

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

## page view的controller
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

index的page类(在目录views/pages下)

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

koa-cola提供一些比较好用的装饰器。

### 可以通过Response装饰器返回固定数据格式
```javascript
  /**
  返回格式:
  [todoItem, ...]
  */
  @Get('/todo/list')
  async getTodoList() {
    return await app.models.todo.find({});
  }
```

使用Response装饰器
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
  返回格式:
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

### 使用Use装饰器验证请求

```javascript
 function isLogin(ctx, next){
    if(ctx.state.user){
        await next();
    }else{
        ctx.throw(401);
    }
}

...
  // 验证用户是否登录，如果没有则返回401
  @Get('/todo/list')
  @Response(Ok)
  @Use(isLogin)
  async getTodoList() {
    return await app.models.todo.find({});
  }
...
```