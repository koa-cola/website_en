---
layout: default
id: universal
title: Universal developing
prev: compare-next.html
next: d-mvc.html
---

<!-- ### 前后端router -->
### front and back ends router

<!-- 通过controller生成server端的react-router，并且也生成client端的react-redux的Provider(里面还是封装了react-router) -->
In the controller,it generate the server-side react-router, and also generate the client side's react-redux provider. (which also wraps the react-router)

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
<!-- 自动生成的server端的react-router: -->
It will auto-generated server-side react-router like this:

```html
<Router ... >
    <Route path="/" component={IndexComponent} />
</Router>
```

<!-- 通过react-router的match到对应的route后，再通过Provider，最终渲染出html： -->
After react-router match to the corresponding route, and then through the Provider, eventually rendering html:

```html
<Provider store={store} key="provider">
    <SomeReduxComponent />
</Provider>
```


<!-- client端Provider则是: -->
Client-side Provider is:

```html
<Provider store={store} key="provider">
    <Router ... >
        <Route path="/" component={IndexComponent} />
    </Router>
</Provider>
```

<!-- ### 前后端redux -->
### front and back ends redux

koa-cola integrates the react-redux.

Client-side redux:

<!-- #### controller 返回 props + 普通 react 组件 -->
#### Controller's data passing to react component

<!-- react组件最终会转换成react-redux组件，在生命周期的render之前，你可以使用redux比如dispatch。 -->
The react component will eventually translates into react-redux components, which you can use with redux, such as dispatch, before the render of the lifecycle.

Controller create data `foo`:

```javascript
@Get('/view')
@View('some_view')
async view( @Ctx() ctx ) { // The controller passes data to the react component's props.ctrl
    return await Promise.resolve({
        foo : 'bar'
    });
} 
```

React component gets controller's data `foo`：

```javascript
function({ctrl : {foo}}){
    return <div>{foo}</div>
}
```

Or 

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

<!-- #### 使用react-redux组件，但是无法获得controller返回的props -->
#### Use react-redux component, ignore the data which controller passed

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

<!-- 或者是经过Cola装饰器封装的react-redux: -->
Or use the react-redux packaged by `@Cola` decorator:

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

<!-- client端的redux -->
client side redux

<!-- 在client可以使用 上面所有形式的 react组件 的redux数据流开发模式，并且没有server端只能在render前使用的限制，可以在组件的生命周期任何时候使用。 -->
The client can use the development mode of redux data stream for all Reagent components above.
Without the restriction that can only be used before render lifecycle on the server side, client side can be used at any time during the lifecycle of the component.

<!-- 但是client端的redux store会依赖server端， 如果server端的store已经经过一系列的数据流操作，那么将会在render阶段之前的数据保存起来，作为client端react-redux的初始化数据（详细查看[redux的createStore](http://redux.js.org/docs/api/createStore.html)），这样就可以完美地将redux数据流从server端无缝衔接到client端。 -->
However, the client side of the redux store will depend on the server side, if the server side of the store has been through a series of data stream operations, 
data will be saved as the client side react-redux initialization data in the render phase. (See [redux createStore](http://redux.js.org/docs/api/createStore.html) for a detailed look)
This will seamlessly connect the redux stream to the client side from the server side.

### Reuse react component on front & back ends

<!-- 从前面react-router和react-redux可以看到react组件是可以完全前后端复用，在前端可以使用react所有功能，但是在server端只能使用render之前的生命周期，包括： -->
From the above mentioned react-router and react-redux can see, react components can be fully reused on both side ends. Frontend can use all the react features.
However, we can only use the lifecycle before render on the server side, including:

* constructor()
* componentWillMount()
* render()

<!-- 如果你的组件会依赖浏览器的dom，如果是在以上生命周期里面调用，则在server端渲染时出错，所以避免出错，你需要判断当前环境，比如：`if(typeof window != 'undefined')`，或者你可以使用这个类似[模拟浏览器端方案](https://github.com/airbnb/enzyme/blob/master/docs/guides/jsdom.md)。 -->
If your component will depend on the browser's DOM, and if it is called in the above life cycle, the server-side render will occur error. So to avoid mistakes, you need to determine the current environment, such as:`if(typeof window != 'undefined')` , Or you can use [simulate browser side scenario](https://github.com/airbnb/enzyme/blob/master/docs/guides/jsdom.md) or something like that.

<!-- ### http api和请求fetch -->
### http api and fetching

<!-- 在前面介绍，也说到过可以使用koa-cola定义的api基类来创建自己的api类，并使用api的fetch方法获取数据： -->
As mentioned earlier, it's also possible to create your own api classes using the api base class defined by koa-cola and get the data using the api's fetch method:

```javascript
const api = new GetTodoList({});
const data = await api.fetch(helpers.ctx);
```

<!-- 上面代码可以兼容服务器端和客户端，ajax库使用了[axios](https://github.com/mzabriskie/axios)，比如 [todolist demo](https://github.com/koa-cola/todolist) 有个react组件定义： -->
The above code is compatible with server-side and client-side, koa-cola uses [axios](https://github.com/mzabriskie/axios) as ajax library.
For example, [todolist demo](https://github.com/koa-cola/todolist) has a react component definition:

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
<!-- 如果该组件的路由是服务器端直接渲染，则`api.fetch`会在服务器端调用，如果该组件是在浏览器端的`<Link>`跳转，则`api.fetch`会在浏览器端调用。 -->
If the component's route is rendered directly on the server side, `api.fetch` will be called on the server side. If the component is on the browser side, then `api.fetch` will be transfer on the browser side.