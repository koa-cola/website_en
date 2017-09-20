---
layout: default
id: ssr
title: SSR和SPA
prev: index.html
next: compare-next.html
---

koa-cola是一个包括前后端全栈的框架。

在服务器端，支持以react作为组件模板的方式直接渲染到浏览器端的SSR（Server Side Render）的架构。

在浏览器端，支持react-router的bundle的SPA(Single Page Application）架构。

SSR和SPA各有优缺点，SPA通过浏览器端router控制页面的跳转，交互体验更友好，但是对于搜索引擎不友好，所以支持SSR是无可避免的，对于开发者，开发koa-cola应用，不需要在写代码时候关心这段代码到底是SSR直渲还是SPA的异步，你只需要关心业务逻辑，koa-cola会帮助你解决代码在不同的环境运行。

```javascript
@asyncConnect([
  {
    key: 'some_data',
    promise: async ({ params, helpers}) => {
      return await fetch('/some/data/api');
    }
  }
])
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
 上面这段是koa-cola项目里面使用了asyncConnect的装饰器来初始化数据。
 
 * 当刷新页面，需要SSR方式直渲Index页面时，服务器端会通过fetch获取数据，然后再渲染出来html。
 * 当在其他页面点击了<link>的react组件时，浏览器端则会通过router找到这个组件，然后在浏览器端使用fetch方法异步获取数据，然后重新在浏览器端渲染页面，这就是SPA方式。

 fetch是一个前后端均可支持的“universal”库，在koa-cola，开发者不但可以前后端使用数据请求接口fetch，甚至可以前后端使用router和redux，和部分组件(在服务器端react组件只支持render之前的生命周期)。
