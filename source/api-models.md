---
layout: default
id: api-models
title: models
prev: api-controllers.html
next: api-schemas.html
---

The folder that place the model layer. We can get the model by using `app.models.todos` at run time. any ORM or ODM model library is supported, as long as export the object.

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

We can also just return the Object in normal way instead of using decorator:

```javascript
export default app.mongoose.model('todos', new app.mongoose.Schema({
    name : String,
    completed : Boolean
}))
```