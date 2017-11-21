---
layout: default
id: decorators
title: 装饰器
prev: installation.html
next: cli.html
---

### Cola 装饰器
定义redux数据初始化，react-redux组件的mapStateToProps和mapDispatchToProps定义，和redux的reducer定义，装饰器可以同时支持服务器端和浏览器端。

```javascript
@Cola({
  initData: {
    todos : async () => {
        return await Promise.resolve([])
    }
  },
  mapStateToProps: state => {
    return {
      // 返回props
    };
  },
  mapDispatchToProps: dispatch => {
    return {
      // 返回props
    };
  },
  reducer: {
    // 这里定义reducer
  }
})
class App extends React.Component<Props, States> {

}
```

### include装饰器
定义当前组件使用的子组件，当子组件使用了Cola装饰器进行数据初始化时候，必须使用include装饰器

```javascript
@Cola({
  initData : {
    prop1 : ({ params, helpers }) => {
      return Promise.resolve('prop1');
    }
  }
})
class Child1 extends React.Component<Props, States>   {
  constructor(props: Props) {
    super(props);
  }
  componentDidMount() {
    // this.props.onLoad();
  }
  render() {
    var result = <div>
      <h3>child1</h3>
      {this.props.prop1}
    </div>
    return result;
  }
};

@Cola({
  initData : {
    prop1 : ({ params, helpers }) => {
      return null;
    }
  }
})
@include({
  Child1
})
class MultiChildren extends React.Component<Props, States> {
  constructor(props: Props) {
    super(props);
  }
  render() {
    var result = (
      <div>
        <div>
          <h3>parent</h3>
          {this.props.prop1}
        </div>
        <Child1 {...this.props} />
      </div>
    );
    return result;
  }
}
```

### doNotUseLayout装饰器
默认page组件会使用views/pages/layout.ts来渲染，如果不使用可以通过定义这个装饰器

```javascript
@doNotUseLayout
class Page extends React.Component<Props, States>   {
  constructor(props: Props) {
      super(props);
  }
  render() {
    return <div>
      <div>wow koa-cola</div>
    </div>
  }
};
```

### header和bundle装饰器
当使用doNotUseLayout装饰器时，如果需要自定义插入header和js bundle，可以使用这两个装饰器
```javascript
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
class Page extends React.Component<Props, States>   {
  constructor(props: Props) {
      super(props);
  }
  render() {
    return <div>
      <div>wow koa-cola</div>
    </div>
  }
};
```