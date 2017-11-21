---
layout: default
id: api-responses
title: responses
prev: api-schemas.html
next: config.html
---

pre-define the format of router return.

for example return json contain code 200 and result：

```javascript
  export default function Ok(ctx, data){
    ctx.status = 200;
    ctx.body = {
        code : 200,
        result : data
    };
  }
```

or return the format of list data：
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