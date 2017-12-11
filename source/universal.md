---
layout: default
id: universal
title: Universal
prev: compare-next.html
next: d-mvc.html
---

### front end and back end router

koa-cola auto generate both front end and back end router

controller:

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
react-router will be auto-generated like this:

```html
<Router ... >
    <Route path="/" component={IndexComponent} />
</Router>
```

In server side after react-router match the react component by a specify route, eventually render view html:

```html
<Provider store={store} key="provider">
    <MatchReduxComponent />
</Provider>
```


Client-side will auto match the route and component, and auto render in browser.

```html
<Provider store={store} key="provider">
    <Router ... >
        <Route path="/" component={IndexComponent} />
    </Router>
</Provider>
```

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


The client side and server side redux can use the any type of the component that mentioned above, and used in any part of component lifecycle.

However, the client side of the redux store will depend on the server side, if the store of server side has been running a series of data stream operations, store data will be saved and as the client side react-redux initial data in `createStore`. (See [redux createStore](http://redux.js.org/docs/api/createStore.html) for detail). So this will magically seamlessly connect the redux data stream from the server side to the client side.

### Reuse react component on front & back ends

the above mentioned react-router, react-redux and react components can be fully reused on both side ends. Frontend can use all the react component features.
However, we can only use the lifecycle before render on the server side, including:

* constructor()
* componentWillMount()
* render()

If your component will depend on the browser's DOM, and called in the above three lifecycle parts, the server-side render will occur error. So to avoid mistakes, you need to determine the current environment, such as:`if(typeof window != 'undefined')` , Or you can use [simulate browser side scenario](https://github.com/airbnb/enzyme/blob/master/docs/guides/jsdom.md) or something like that.

### http api and fetching

As mentioned earlier, it's also possible to create your own api classes using the api base class defined by koa-cola and get the data by using the these apis:

```javascript
const api = new GetTodoList({});
const data = await api.fetch(helpers.ctx);
```

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
