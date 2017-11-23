---
layout: default
id: views-pages
title: pages
prev: views.html
next: views-app.html
---

views/pages place page components.

in controller, define a method with a `View` decorator:
```javascript
@Get('/some_page')  
@View('some_page')
some_page () {}
```

when visit `/some_page` in server side koa-cola will get  `views/pages/some_page.tsx` as page view to render to client, in client side, webpack will build these router and component into bundle and auto render in browser.

when raised a error like 404 or 500, koa-cola will looking for the correspondent file in views/pages like `404.tsx` or `500.tsx`.

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

if you don't want a particular page to use layout.ts as the page wrapper, you can use decorator "doNotUseLayout" like this:

```javascript
const {doNotUseLayout} = require('koa-cola/client');
@doNotUseLayout
class Page extends React.Component<Props, States>   {
    ...
}
```

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