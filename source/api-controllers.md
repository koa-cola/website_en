---
layout: default
id: api-controllers
title: controllers
next: api-models.html
---

The controller directory holds the `controller` class, and the `controller` class define controller by decorator Controller from `require('koa-cola/client')`. and we can define the router and view by decorators as well, so We can design different controllers according to different production needs.

## Controller that provides api interface

```javascript
const { Controller, Get, Post, Body } = require('koa-cola/client');

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

### Return fixed data format by return of router

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

return a pre-define wrapper data format by using Response decorator
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

### Using `Use` decorator as middleware of router

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