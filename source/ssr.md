---
layout: default
id: ssr
title: SSR & SPA
prev: index.html
next: compare-next.html
---

<!-- koa-cola是一个包括前后端全栈的框架。 -->
koa-cola is a SSR/SPA solution framework.

<!-- 在服务器端，支持以react作为组件模板的方式 直接渲染到浏览器端的SSR（Server Side Render）的架构。 -->
On the server side, koa-cola support SSR(Server Side Render), which using react as a template component and render view to client. 

<!-- 在浏览器端，支持react-router的bundle的SPA(Single Page Application）架构。 -->
On the client side, js bundle base on react-router and redux and run as SPA(Single Page Application) architecture.

<!-- SSR和SPA各有优缺点，SPA通过浏览器端router控制页面的跳转，交互体验更友好，但是对于搜索引擎不友好，所以支持SSR是无可避免的，对于开发者，开发koa-cola应用，不需要在写代码时候关心这段代码到底是SSR直渲还是SPA的异步，你只需要关心业务逻辑，koa-cola会帮助你解决代码在不同的环境运行。 -->
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
 <!-- 上面这段是koa-cola项目里面使用了Cola的装饰器来初始化数据。 -->
 The react component is using Cola decorator to initialize data in the koa-cola project.
 
 <!-- * 当刷新页面，需要SSR方式直渲Index页面时，服务器端会通过fetch获取数据，然后再渲染出来html。 -->
 * In SSR mode, before page loaded, koa-cola will fetch data first in server side, then render html to client.
 <!-- * 当在其他页面点击了<link>的react组件时，浏览器端则会通过router找到这个组件，然后在浏览器端使用fetch方法异步获取数据，然后重新在浏览器端渲染页面，这就是SPA方式。 -->
 * In SPA mode, like when click `<link>` in browser, koa-cola will call fetch api in browser, then re-render the component in client side.

 so yes, you can see the codes above demostrate that both client and server side use react/redux/fetch.


