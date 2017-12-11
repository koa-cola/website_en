---
layout: default
id: tip5-debug
title: Debugging
prev: tip4-cluster.html
next: tip6-compile.html
---

When debugging a koa-cola project, we need to add two dependencies: 

```shell
npm i ts-node typescript -S
```

and add debug config in vscode:

```json
{
    "name": "DebugApp",
    "type": "node",
    "request": "launch",
    "program": "${workspaceRoot}/node_modules/ts-node/dist/_bin.js",
    "stopOnEntry": false,
    "args": [],
    "runtimeArgs": [
        "-r", "ts-node/register",
        "${workspaceRoot}/app.ts"
    ],
    "sourceMaps": true,
    "console": "internalConsole",
    "internalConsoleOptions": "openOnSessionStart"
}
```
<!-- 便可享受vscode的调试ts的乐趣。另外，koa-cola加了redux调试支持，你也可以使用chrome的redux插件调试： -->
Then we can debug ts via vscode.

In addition, koa-cola integrate redux debug tool, we can use the chrome's redux plug-in:

<img src="https://github.com/hcnode/koa-cola/raw/master/screenshots/dev-tool.png" alt="Drawing" width="600"/>
