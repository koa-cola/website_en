---
layout: default
id: compare-next
title: 对比next.js
prev: ssr.html
next: universal.html
---

[next.js](https://github.com/zeit/next.js)是一个比较流行的也是基于react的SSR的应用框架，不过在react技术栈，next.js支持component和react-router，并没有集成redux，在服务器端，也没有太多支持，比如controller层和express/koa中间件，服务器端只是支持简单的路由、静态页面等，koa-cola则是提供前后端完整的解决方案的框架。

## 数据初始化对比

在数据初始化，两者有点类似，next.js使用静态方法getInitialProps来初始化数据：

```javascript
import React from 'react'
export default class extends React.Component {
  static async getInitialProps ({ req }) {
    return req
      ? { userAgent: req.headers['user-agent'] }
      : { userAgent: navigator.userAgent }
  }
  render () {
    return <div>
      Hello World {this.props.userAgent}
    </div>
  }
}
```

koa-cola提供[两种方式](/doc/tip1-react-init.html)来进行数据初始化，更加灵活。

## 子组件初始化

next.js不支持子组件的数据初始化：

Note: getInitialProps can not be used in children components. Only in pages.

koa-cola则只需要加上decorator "include", 完全支持所有的子组件的数据初始化。

```javascript
import * as React from 'react';

const {
  asyncConnect,
  include
} = require('koa-cola').Decorators.view;
// Child1, Child2 是asyncConnect的组件，并且会进行数据初始化
const Child1 = require('../components/child1').default;
const Child2 = require('../components/child2').default;

export interface Props {}
export interface States {}

@asyncConnect([])
@include({
  Child1,
  Child2
})
class MultiChildren extends React.Component<Props, States> {
  constructor(props: Props) {
    super(props);
  }
  render() {
    return <div>
        <Child1 {...this.props} />
        <Child2 {...this.props} />
      </div>
  }
}

export default MultiChildren;

```

koa-cola不但可以支持component的数据初始化，还可以合并page和component的reducer，使用同一个store，page和component的redux无缝结合。详细可参考[多子组件的redux页面例子源码](https://github.com/hcnode/koa-cola/blob/master/app_test/views/pages/multiChildren.tsx)和[在线Demo](http://koa-cola.com:3001/multiChildren)

