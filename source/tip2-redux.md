---
layout: default
id: tip2-redux
title: redux-connect组件的redux坑
prev: tip1-react-init.html
next: tip3-inject-global.html
---


使用redux-connect进行数据初始化，如果这个key和自定义的mapStateToProps的props属性有冲突，那么key定义的数据将会更优先

下面例子，定义了初始化的props属性foo，然后mapStateToProps也定义了返回的props.foo的新value，但是，其实dispatch后props.foo还是最开始的"bar"，而不是"bar again"。

```javascript
const {asyncConnect, colaReducer, store} = require('koa-cola').Decorators.view;
@asyncConnect([
  {
    key: 'foo',
    promise: async ({ params, helpers, store: { dispatch } }) => {
        return await Promise.resolve('bar');
    }
  }
], // mapStateToProps
({ fooState }) => {
    return {
        foo : fooState
    };
}, dispatch => {
    return {
        changeFoo: () => {
            dispatch({
                type: 'CHANGE_FOO'
            });
        }
    };
})
@colaReducer({
    fooState : (state = '', action) => {
        switch (action.type) {
            case 'CHANGE_FOO':
                return 'bar again';
            default:
                return state;
        }
    }
})
class Some_Page extends React.Component<Props, States> {
  constructor(props: Props) {
    super(props);
  }
  render() {
    return <div>
        {this.props.foo}
        <button onClick={() => this.props.changeFoo()}>change foo</button>
    </div>;
  }
}
export default Some_Page;
```

如果必须要修改props.foo，可以使用下面的方法。

```javascript
const loadSuccess = store.loadSuccess;
...
...
changeFoo: () => {
    dispatch(loadSuccess('foo', 'bar again'));
}
```