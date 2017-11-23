---
layout: default
id: universal
title: Universal developing
prev: compare-next.html
next: d-mvc.html
---

<!-- ### 前后端router -->
### front end and back end router

<!-- 通过controller生成server端的react-router，并且也生成client端的react-redux的Provider(里面还是封装了react-router) -->
koa-cola auto generate both front end and back ends router

in controller:

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
react-router will be auto-generated like this:

```html
<Router ... >
    <Route path="/" component={IndexComponent} />
</Router>
```

<!-- 通过react-router的match到对应的route后，再通过Provider，最终渲染出html： -->
In server side after react-router match the react component by a specify route, eventually render view html:

```html
<Provider store={store} key="provider">
    <MatchReduxComponent />
</Provider>
```


<!-- client端Provider则是: -->
Client-side will auto match the route and component, and auto render in browser.

```html
<Provider store={store} key="provider">
    <Router ... >
        <Route path="/" component={IndexComponent} />
    </Router>
</Provider>
```

<!-- ### 前后端redux -->
### front end and back end redux

koa-cola integrates the react-redux in both sides.

react-redux component:

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
Or use the react-redux base `@Cola` decorator:

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


<!-- 在client可以使用 上面所有形式的 react组件 的redux数据流开发模式，并且没有server端只能在render前使用的限制，可以在组件的生命周期任何时候使用。 -->
The client side and server side redux can use the any type of the component that mentioned above, and used in any part of component lifecycle.

<!-- 但是client端的redux store会依赖server端， 如果server端的store已经经过一系列的数据流操作，那么将会在render阶段之前的数据保存起来，作为client端react-redux的初始化数据（详细查看[redux的createStore](http://redux.js.org/docs/api/createStore.html)），这样就可以完美地将redux数据流从server端无缝衔接到client端。 -->
However, the client side of the redux store will depend on the server side, if the store of server side has been running a series of data stream operations, store data will be saved and as the client side react-redux initial data in `createStore`. (See [redux createStore](http://redux.js.org/docs/api/createStore.html) for detail). So this will magically seamlessly connect the redux data stream from the server side to the client side.

### Reuse react component on front & back ends

<!-- 从前面react-router和react-redux可以看到react组件是可以完全前后端复用，在前端可以使用react所有功能，但是在server端只能使用render之前的生命周期，包括： -->
the above mentioned react-router, react-redux and react components can be fully reused on both side ends. Frontend can use all the react component features.
However, we can only use the lifecycle before render on the server side, including:

* constructor()
* componentWillMount()
* render()

<!-- 如果你的组件会依赖浏览器的dom，如果是在以上生命周期里面调用，则在server端渲染时出错，所以避免出错，你需要判断当前环境，比如：`if(typeof window != 'undefined')`，或者你可以使用这个类似[模拟浏览器端方案](https://github.com/airbnb/enzyme/blob/master/docs/guides/jsdom.md)。 -->
If your component will depend on the browser's DOM, and called in the above three lifecycle parts, the server-side render will occur error. So to avoid mistakes, you need to determine the current environment, such as:`if(typeof window != 'undefined')` , Or you can use [simulate browser side scenario](https://github.com/airbnb/enzyme/blob/master/docs/guides/jsdom.md) or something like that.

<!-- ### http api和请求fetch -->
### http api and fetching

<!-- 在前面介绍，也说到过可以使用koa-cola定义的api基类来创建自己的api类，并使用api的fetch方法获取数据： -->
As mentioned earlier, it's also possible to create your own api classes using the api base class defined by koa-cola and get the data by using the these apis:

```javascript
const api = new GetTodoList({});
const data = await api.fetch(helpers.ctx);
```

<!-- 上面代码可以兼容服务器端和客户端，ajax库使用了[axios](https://github.com/mzabriskie/axios)，比如 [todolist demo](https://github.com/koa-cola/todolist) 有个react组件定义： -->
The above codes can be run both in server-side and client-side, koa-cola use [axios](https://github.com/mzabriskie/axios) as ajax library.
For example:

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
