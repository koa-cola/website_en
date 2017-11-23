---
layout: default
id: views-pages
title: pages
prev: views.html
next: views-app.html
---

<!-- views/pages下的页面page组件是koa-cola路由router配置服务器端html输入模板，浏览器端的react component输入对象。 -->
views/pages place page components.

<!-- 在controller配置路由的时候配置了view装饰器： -->
in controller, define a method with a `View` decorator:
```javascript
@Get('/some_page')  
@View('some_page')
some_page () {}
```

when visit `/some_page` in server side koa-cola will get  `views/pages/some_page.tsx` as page view to render to client, in client side, webpack will build these router and component into bundle and auto render in browser.
<!-- 当浏览器访问/some_page时，服务器端koa-cola会选择views/pages/some_page.tsx作为渲染的模板，浏览器端，webpack会把<router>打包到bundle，并且对应的router会配置controller对应的path和page对应的react component。 -->

<!-- views/pages下如果配置了404.tsx或者500.tsx时，如果koa进入对应的异常，则会使用对应的组件进行渲染。 -->
when raised a error like 404 or 500, koa-cola will looking for the correspondent file in views/pages like `404.tsx` or `500.tsx`.

<!-- views/pages/layout.ts是page最终在服务器端渲染的时候生成的html输入模板，如果没有此文件，则直接输入页面组件的html。 -->
views/pages/layout.ts is as the layout file koa-cola eventually render the page, if the file does not exist, the page component will render directly.

layout.ts by default:
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

<!-- 服务器端koa-cola在输出html之前会加上store初始化状态在script里面，所以bundle引用需要放在__data之后： -->
koa-cola render `window.__data` as redux store serialization after `</body>`.

```html
<!doctype html>
<html>
    <body id="app">${html}</body>
    <script>
        window.__data= {/*json of redux store*/}
    </script>
</html>
<!-- bundle js goes after window.__data, only one bundle.js by default, seperate into serveral bundle js if needed -->
<script src="/bundle.js"></script>
```

<!-- react page组件也支持不使用layout的方式选渲染。 -->
if you don't want a particular page to use layout.ts as the page wrapper, you can use decorator "doNotUseLayout" like this:

```javascript
const {doNotUseLayout} = require('koa-cola/client');
@doNotUseLayout
class Page extends React.Component<Props, States>   {
    ...
}
```

<!-- 这种情况，你可以使用自定义header和bundle的装饰器： -->
and in this case, you can define the header element and bundle js or other resource like css by using decorator `bundle` and `header` like this:

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