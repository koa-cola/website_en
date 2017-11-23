---
layout: default
id: ssr
title: SSR & SPA
prev: index.html
next: compare-next.html
---

koa-cola is a SSR/SPA solution framework.

On the server side, koa-cola support SSR(Server Side Render), which using react as a template component and render view to client. 

On the client side, js bundle base on react-router and redux and run as SPA(Single Page Application) architecture.

either SSR or SPA has each cons and pros, but when they work together in koa-cola, then you will have both pros and avoid cons. 
SPA of course have better user experience, but it is bad for search engine. 
develop SSR/SPA by using koa-cola, we don't need to care about the code we are writing whether need to be running in SSR or SPA. actually they run in both environment like react component/redux/ajax. what you care about is only business logic. koa-cola will resolve issues in these different environments.

let us take codes below for example

```javascript
@Cola({
  initData : {
    some_data : async ({ params, helpers}) => {
      return await fetch('/some/data/api');
    }
  }
})
class Index extends React.Component<Props, States> {
  constructor(props: Props) {
    super(props);
  }
  render() {
    return <div>
        {this.props.some_data}
    </div>;
  }
}
export default Index;
```
 The react component is using Cola decorator to initialize data in the koa-cola project.
 
 * In SSR mode, before page loaded, koa-cola will fetch data first in server side, then render html to client.
 * In SPA mode, like when click `<link>` in browser, koa-cola will call fetch api in browser, then re-render the component in client side.

 so yes, you can see the codes above demostrate that both client and server side use react/redux/fetch.


