---
layout: default
id: views-pages
title: pages
prev: views.html
next: views-app.html
---

views/pages下的页面page组件是koa-cola路由router配置服务器端html输入模板，浏览器端的react component输入对象。

在controller配置路由的时候配置了view装饰器：
```javascript
@Get('/some_page')  
@View('some_page')
some_page () {}
```

当浏览器访问/some_page时，服务器端koa-cola会选择views/pages/some_page.tsx作为渲染的模板，浏览器端，webpack会把<router>打包到bundle，并且对应的router会配置controller对应的path和page对应的react component。

views/pages下如果配置了404.tsx或者500.tsx时，如果koa进入对应的异常，则会使用对应的组件进行渲染。

views/pages/layout.ts是page最终在服务器端渲染的时候生成的html输入模板，如果没有此文件，则直接输入页面组件的html。

```javascript
export default function(html){
    return `
    <!doctype html>
    <html>
        <body id="app">${html}</body>
    </html>
    <script src="/bundle.js"></script>
        `
}
```

服务器端koa-cola在输出html之前会加上store初始化状态在script里面，所以bundle引用需要放在__data之后：

```html
<!doctype html>
<html>
    <body id="app">${html}</body>
    <script>
        window.__data= {/*json of redux store*/}
    </script>
</html>
<!-- bundle js根据需要引用，比如默认build到public，或者cdn，或者你也可以修改webpack配置，build按需加载的js或者vendor js等 -->
<script src="/bundle.js"></script>
```

react page组件也支持不使用layout的方式选渲染。

```javascript
const {doNotUseLayout} = require('koa-cola/client');
@doNotUseLayout
class Page extends React.Component<Props, States>   {
    ...
}
```

这种情况，你可以使用自定义header和bundle的装饰器：

```javascript
const {header, bundle, doNotUseLayout} = require('koa-cola/client');
@doNotUseLayout
@bundle([
  "/bundle.js",
  "/test.js"
])
@header(() => {
  return <head>
    <meta name="viewport" content="width=device-width" />
  </head>
})
class Page extends React.Component<Props, States>   {
    ...
}
```