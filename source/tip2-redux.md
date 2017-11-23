---
layout: default
id: tip2-redux
title: Using redux in Cola
prev: tip1-react-init.html
next: tip3-inject-global.html
---

## About the props key name conflicts between `Cola` and `mapStateToProps`
Using `Cola` decorators for data initialization, it's better to use the different key name of `initData` and `mapStateToProps`.
If the key name in `initData` conflicts with the name defined in `mapStateToProps` , data in `initData` will be prior than `mapStateToProps`.

The following example defines the data `foo`, and `mapStateToProps` also defines `foo`. and execute `dispatch` to change `foo` value to `bar again`, but as we had set `foo` in the `initData`, the dispatching action will not work, `foo` value will still be `bar`.

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

If you still want to change `props.foo`, you can use `dispatch(loadSuccess(...));` :

```javascript
const loadSuccess = store.loadSuccess;
...
...
changeFoo: () => {
    dispatch(loadSuccess('foo', 'bar again'));
}
```