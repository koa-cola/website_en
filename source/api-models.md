---
layout: default
id: api-models
title: models
prev: api-controllers.html
next: api-schemas.html
---

保存model对象的目录，在运行时可以使用`app.models.todos`获取model对象，可以使用任何ORM或者ODM模型库，只要export出该对象就可以了。
The directory that saves the model. We can get the model using `app.models.todos` at run time.
We can use any ORM or ODM model library, as long as we export the object.

For example, use mongoose：

```javascript
import {model} from 'mongoose-decorators';
const todoSchema = new app.mongoose.Schema({
    name : String,
    completed : Boolean
})
@model(todoSchema)
export default class todos {}
```

In addition to using the model decorator, we can also use other decorator of (mongoose-decorators)[https://github.com/aksyonov/mongoose-decorators].

We can also not using any decorator:

```javascript
export default app.mongoose.model('todos', new app.mongoose.Schema({
    name : String,
    completed : Boolean
}))
```