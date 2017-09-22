---
layout: default
id: universal
title: Universal 前后端全栈开发
prev: compare-next.html
next: d-mvc.html
---

### 前后端router

通过controller生成server端的react-router，并且也生成client端的react-redux的Provider(里面还是封装了react-router)

```javascript
@Controller('') 
class FooController {
    @Get('/')
    @View('index')
    index(@Ctx() ctx) {
        return '<h1>hello koa-cola !</h1>'
    }
}
```
自动生成的server端的react-router:

```html
<Router ... >
    <Route path="/" component={IndexComponent} />
</Router>
```

通过react-router的match到对应的route后，再通过Provider，最终渲染出html：
```html
<Provider store={store} key="provider">
    <SomeReduxComponent />
</Provider>
```


client端Provider则是:
```html
<Provider store={store} key="provider">
    <Router ... >
        <Route path="/" component={IndexComponent} />
    </Router>
</Provider>
```

### 前后端redux

koa-cola集成了react-redux方案

server端redux:

#### controller返回props+普通react组件

react组件最终会转换成react-redux组件，在生命周期的render之前，你可以使用redux比如dispatch。

```javascript
@Get('/view')
@View('some_view')
async view( @Ctx() ctx ) { // controller返回数据传递到react组件的props.ctrl
    return await Promise.resolve({
        foo : 'bar'
    });
} 
```

react组件：

```javascript
function({ctrl : {foo}}){
    return <div>{foo}</div>
}
```

或者

```javascript
class Page extends React.Component<Props, States>   {
    constructor(props: Props) {
        super(props);
    }
    render() {
        return <div>{this.props.ctrl.foo}</div>
    }
};
```
#### 使用react-redux组件，但是无法获得controller返回的props

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

或者是经过redux-connect封装的react-redux:

```javascript
const {Cola} = require('koa-cola/client');

@Cola({
    initData : {
        foo : async ({ params, helpers}) => {
            return await Promise.resolve('this will go to this.props.some_props')
        }
    },
    mapStateToProps,
    mapDispatchToProps
})
class Index extends React.Component<Props, States>   {
    constructor(props: Props) {
        super(props);
    }
    render() {
        return <h1>{this.props.foo}</h1>
    }
};
export default Index
```

client端的redux

在client可以使用上面所有形式的react组件的redux数据流开发模式，并且没有server端只能在render前使用的限制，可以在组件的生命周期任何时候使用。

但是client端的redux store会依赖server端，如果server端的store已经经过一系列的数据流操作，那么将会在render阶段之前的数据保存起来，作为client端react-redux的初始化数据（详细查看[redux的createStore](http://redux.js.org/docs/api/createStore.html)），那么这样就可以完美地redux数据流从server端无缝衔接到client端。

### react组件的前后端复用

从前面react-router和react-redux可以看到react组件是可以完全前后端复用，在前端可以使用react所有功能，但是在server端只能使用render之前的生命周期，包括：

* constructor()
* componentWillMount()
* render()

如果你的组件会依赖浏览器的dom，如果是在以上生命周期里面调用，则在server端渲染时出错，所以避免出错，你需要判断当前环境，比如：`if(typeof window != 'undefined')`，或者你可以使用这个类似[模拟浏览器端方案](https://github.com/airbnb/enzyme/blob/master/docs/guides/jsdom.md)。

### http api和请求fetch

在前面介绍，也说到过可以使用koa-cola定义的api基类来创建自己的api类，并使用api的fetch方法获取数据：

```javascript
const api = new GetTodoList({});
const data = await api.fetch(helpers.ctx);
```

上面代码可以兼容服务器端和客户端，ajax库使用了[axios](https://github.com/mzabriskie/axios)，比如 [todolist demo](https://github.com/koa-cola/todolist) 有个react组件定义：

```javascript
@Cola({
    initData : {
        todosData : async ({ params, helpers, store: { dispatch } }) => {
            const api = new GetTodoList({});
            const data = await api.fetch(helpers.ctx);
            return data.result.result;
        }
    }
})
class Page extends React.Component<Props, States> {
  ...
}
export default Page;
```
如果该组件的路由是服务器端直接渲染，则`api.fetch`会在服务器端调用，如果该组件是在浏览器端的`<Link>`跳转，则`api.fetch`会在浏览器端调用。