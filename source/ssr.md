---
layout: default
id: ssr
title: SSR & SPA
prev: index.html
next: compare-next.html
---

<!-- koa-cola是一个包括前后端全栈的框架。 -->
koa-cola is a full stack framework.

<!-- 在服务器端，支持以react作为组件模板的方式 直接渲染到浏览器端的SSR（Server Side Render）的架构。 -->
On the server side, koa-cola support SSR(Server Side Render), which using react as a template component and render view to client. 

<!-- 在浏览器端，支持react-router的bundle的SPA(Single Page Application）架构。 -->
On the client side, koa-cola bundle react-router and run as SPA(Single Page Application).

<!-- SSR和SPA各有优缺点，SPA通过浏览器端router控制页面的跳转，交互体验更友好，但是对于搜索引擎不友好，所以支持SSR是无可避免的，对于开发者，开发koa-cola应用，不需要在写代码时候关心这段代码到底是SSR直渲还是SPA的异步，你只需要关心业务逻辑，koa-cola会帮助你解决代码在不同的环境运行。 -->
SSR or SPA has both side effect to the production, but when they work together, they complement each other. 
SPA switch pages with client side router friendly to UX, but not to the search engine. So add SSR to SPA can fix it's problem.
For developer, when using koa-cola, we don't need to take attention about whether the code we writing need to be SSR or SPA. It has both. We just need to take care about the function logic. koa-cola will help us resolve running well at different kind of environment.

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
 Above example code is using Cola decorator to initialize data in the koa-cola project.
 
 <!-- * 当刷新页面，需要SSR方式直渲Index页面时，服务器端会通过fetch获取数据，然后再渲染出来html。 -->
 * When refreshing page on client side, it will use SSR way to render the page, and server will fetch data, and render Html.
 <!-- * 当在其他页面点击了<link>的react组件时，浏览器端则会通过router找到这个组件，然后在浏览器端使用fetch方法异步获取数据，然后重新在浏览器端渲染页面，这就是SPA方式。 -->
 * When we click a react component `<link>` at browser, all motions will run locally, it finds the component by the router, and fetch data at client side asynchronously, then render the page. This is what SPA works.

 <!-- fetch是一个前后端均可支持的“universal”库，在koa-cola，开发者不但可以前后端使用数据请求接口fetch，甚至可以前后端使用router和redux，和部分组件(在服务器端react组件只支持render之前的生命周期)。 -->
 `fetch` is a "universal" library that support running at both frontend and backend. Using koa-cola, developer can request data through the fetch. Further, on both end of side, we can use router and redux or some other component (on the server side, react component only support the life cycle before render).
