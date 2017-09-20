---
layout: default
id: api-models
title: models
prev: api-controllers.html
next: api-schemas.html
---

保存model对象的目录，在运行时可以使用`app.models.todos`获取model对象，可以使用任何ORM或者ODM模型库，只要export出该对象就可以了。

比如使用mongoose：

```javascript
import {model} from 'mongoose-decorators';
const todoSchema = new app.mongoose.Schema({
    name : String,
    completed : Boolean
})
@model(todoSchema)
export default class todos {}
```

除了使用model装饰器，你还可以使用(mongoose-decorators)[https://github.com/aksyonov/mongoose-decorators]的其他装饰器。

或者你也可以不使用装饰器：

```javascript
export default app.mongoose.model('todos', new app.mongoose.Schema({
    name : String,
    completed : Boolean
}))
```