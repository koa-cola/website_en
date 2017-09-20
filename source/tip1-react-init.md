---
layout: default
id: tip1-react-init
title: 初始化react组件数据
next: tip2-redux.html
---

koa-cola提供两种方式初始化react。

## 在controller里面初始化

初始化数据，数据将会注入到react组件的props.ctrl，如：this.props.ctrl.foo

```javascript
const { Controller, Get, Use, Param, Body, Delete, Put, Post, QueryParam, View, Ctx, Response } = require('koa-cola').Decorators.controller;
@Controller('') 
class FooController {
    @Get('/some_page')  
    @View('some_page') // some_page是普通react组件
    async some_page (@Ctx() ctx, @QueryParam() param : any) { 
        // 初始化数据，数据将会注入到react组件的props，如：this.props.ctrl.foo
        return await Promise.resolve({
            foo : 'bar'
        });
    }
}
```

## 在redux-connect封装的react组件初始化数据
```javascript
const {asyncConnect} = require('koa-cola').Decorators.view;

// 变量描述
export interface Props {
    foo: string;   
}
export interface States {}

@asyncConnect([
  {
    key: 'foo',
    promise: async ({ params, helpers, store: { dispatch } }) => {
        return await Promise.resolve('bar');
    }
  }
])
class Some_Page extends React.Component<Props, States> {
  constructor(props: Props) {
    super(props);
  }
  render() {
    return <div>{this.props.foo}</div>;
  }
}
export default Some_Page;
```

这两种方式的区别是：

第一种方式：
* 只会在服务器端进行初始化
* 只支持非react-redux或者redux-connect封装的组件
* 因为只会在服务器端进行初始化，所以可以支持任何获取数据的方式比如数据库获取

第二种方式：
* 服务器端和浏览器端都支持（服务器端就是SSR，浏览器端就是异步获取数据）
* redux-connect封装的组件
* 因为服务器端和浏览器端都支持初始化，所以数据的获取必须前后端Universal，比如使用axios库