---
layout: default
id: api-responses
title: responses
prev: api-schemas.html
next: config.html
---

使用responses可以定义固定的接口数据返回格式。

比如普通的返回：

```javascript
  export default function Ok(ctx, data){
    ctx.status = 200;
    ctx.body = {
        code : 200,
        result : data
    };
  }
```

或者返回列表：
```javascript
  export default function List(ctx, {data, page, page_count, total_count}){
    ctx.status = 200;
    ctx.body = {
        code : 200,
        result : {
            list : data,
            _metadata: {
                page: 51,
                page_count: 20,
                total_count: 521
            }
        }
    };
  }
```