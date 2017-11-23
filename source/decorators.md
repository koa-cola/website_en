---
layout: default
id: decorators
title: Decorators
prev: installation.html
next: cli.html
---

### Cola decorator
`Cola` decorator can define redux initial data, `mapStateToProps` and `mapDispatchToProps` for react-redux components, and reducers for redux as well. Decorator support both server-side and browser-side.

```javascript
@Cola({
  initData: {
    // return any data in props
    todos : async () => {
        return await Promise.resolve([])
    }
  },
  mapStateToProps: state => {
    return {
      // return props
    };
  },
  mapDispatchToProps: dispatch => {
    return {
      // return props
    };
  },
  reducer: {
    // define reducer here
  }
})
class App extends React.Component<Props, States> {

}
```

### include decorator
`include` decorator indicate the component contain children components defined by Cola decorator.

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

### doNotUseLayout decorator

By default, page component will render with `views/pages/layout.ts`, if we don't need that layout, you can use this decorator:

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

### header & bundle decorator

When using `doNotUseLayout` decorator, if you need to custom header and resource, you can use these two decorators.

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