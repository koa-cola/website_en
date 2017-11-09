---
layout: default
id: tip2-redux
title: Using redux in Cola
prev: tip1-react-init.html
next: tip3-inject-global.html
---

## About the data key name conflicts between `Cola` and `mapStateToProps`
<!-- 使用Cola装饰器进行数据初始化，如果这个key和自定义的mapStateToProps的props属性有冲突，那么key定义的数据将会更优先 -->
Using `Cola` decorators for data initialization, it's better to use the different key name of `initData` and `mapStateToProps`.
If the key name in `initData` conflicts with the name defined in `mapStateToProps` , data in `initData` will be given priority.

<!-- 下面例子，定义了初始化的props属性foo，然后mapStateToProps也定义了返回的props.foo的新value，但是，其实dispatch后props.foo还是最开始的"bar"，而不是"bar again"。 -->
The following example defines the data `foo`, and `mapStateToProps` also defines `foo`. The fact is, when execute `dispatch` and purpose to modify `foo` value to `bar again`, but as we have set `foo` in the `initData`, the dispatching action will not work, `foo` value will still be `bar`.

```javascript
const {Cola, store} = require('koa-cola/client');
@Cola({
    initData : {
        foo : async ({ params, helpers, store: { dispatch } }) => {
            return await Promise.resolve('bar');
        }
    },
    mapStateToProps : ({ fooState }) => {
        return {
            foo : fooState
        };
    },
    mapDispatchToProps : dispatch => {
        return {
            changeFoo: () => {
                dispatch({
                    type: 'CHANGE_FOO'
                });
            }
        };
    },
    reducer : {
        fooState : (state = '', action) => {
            switch (action.type) {
                case 'CHANGE_FOO':
                    return 'bar again';
                default:
                    return state;
            }
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

If you have to modify `props.foo`, you can use the following method:

```javascript
const loadSuccess = store.loadSuccess;
...
...
changeFoo: () => {
    dispatch(loadSuccess('foo', 'bar again'));
}
```