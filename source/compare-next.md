---
layout: default
id: compare-next
title: Compare with next.js
prev: ssr.html
next: universal.html
---

[next.js](https://github.com/zeit/next.js) is one of the popular SSR and reactjs base frameworks, but some difference between koa-cola and next.js.

### fetch data
next.js provide static method "getInitialProps" to fetch data：
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

koa-cola provide two ways to fetch data.

1. use Cola decorator to fetch data:
```javascript
import React from 'react'
var { Cola } = require('koa-cola/client');

@Cola({
  initData : {
    userAgent : req
      ? { userAgent: req.headers['user-agent'] }
      : { userAgent: navigator.userAgent }
  }
})
export default class extends React.Component {
  render () {
    return <div>
      Hello World {this.props.userAgent}
    </div>
  }
}
```

2. fetch data in server router
```javascript
// in controller
@Controller('') 
class FooController {
    @Get('/some_page')  
    @View('some_page') 
    some_page (@Ctx() ctx) { 
      return userAgent: ctx.req.headers['user-agent']
    }
}

// in page
export default function({ ctrl : {userAgent} }) {
  return <div>
    Hello World {userAgent}
  </div>
}
```

the first way fetch data in koa-cola props actually come from react-redux, because koa-cola combines all pages reducer into redux, so in browser espcially in SPA, you can share this kind of props in all pages. while next.js has not support this yet.

### support children components data fetch

next.js does not support fetch data in children components:
> Note: getInitialProps can not be used in children components. Only in pages.

but in koa-cola this can easy be supported by using the decorator "include":

```javascript
// in child component
@Cola({
  initData : {
    userAgent : req
      ? { userAgent: req.headers['user-agent'] }
      : { userAgent: navigator.userAgent }
  }
})
class Child extends React.Component {
  render () {
    return <div>
      Hello World {this.props.userAgent}
    </div>
  }
}


// in page
var { Cola, include } = require('koa-cola/client');
@include({
  Child
})
export default class Page extends React.Component{
  render() {
    return <div>
        <Child {...this.props} />
      </div>
  }
}

```