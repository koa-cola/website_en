---
layout: default
id: tip1-react-init
title: React component data initialization
next: tip2-redux.html
---

koa-cola Use Cola decorator's components to initialize data

```javascript
const {Cola} = require('koa-cola/client');

// Variable Description
export interface Props {
    foo: string;   
}
export interface States {}

@Cola({
  initData : {
    foo : async ({ params, helpers, store: { dispatch } }) => {
        return await Promise.resolve('bar');
    }
  }
})
class Some_Page extends React.Component<Props, States> {
  constructor(props: Props) {
    super(props);
  }
  render() {
    return <div>{this.props.foo}</div>;
  }
}
export default Some_Page;
```
