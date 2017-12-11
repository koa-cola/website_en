---
layout: default
id: tip1-react-init
title: React component data initialization
next: tip2-redux.html
---

koa-cola provides two ways to initialize react data.

## Initialization inside controller

When initialize data, data will be injected into the react component `props.ctrl`, like:

```javascript
const { Controller, Get, Use, Param, Body, Delete, Put, Post, QueryParam, View, Ctx, Response } = require('koa-cola/client');
@Controller('') 
class FooController {
    @Get('/some_page')  
    @View('some_page') // some_page is a common react component
    async some_page (@Ctx() ctx, @QueryParam() param : any) { 
        // data will be injected into the react component's props. 
        // inside the component we can get "foo" by "this.props.ctrl.foo"
        return await Promise.resolve({
            foo : 'bar'
        });
    }
}
```

## Use Cola decorator's components to initialize data
```javascript
const {Cola} = require('koa-cola/client');

// Variable Description
export interface Props {
    foo: string;   
}
export interface States {}

@Cola({
  initData : {
    foo : async ({ params, helpers, store: { dispatch } }) => {
        return await Promise.resolve('bar');
    }
  }
})
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

The difference between these two data-init ways is:

The first way:
* Will only be initialized on the server side.
* Only get data inside react component.
* Because only running on the server side, so you can do anything like fetch data from database.

The second way:
* Server-side and browser-side supported (server side is SSR, browser side is fetching data)
* use Cola decorator component
* Because it support both side to run, data acquisition must support server and browser environment.
