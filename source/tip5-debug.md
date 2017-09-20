---
layout: default
id: tip5-debug
title: 调试
prev: tip4-cluster.html
next: tip6-compile.html
---

如果需要调试koa-cola项目，需要添加两个依赖`npm i ts-node typescript -S`，然后在vscode新建调试配置：

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
便可享受vscode的调试ts的乐趣。

另外，koa-cola加了redux调试支持，你也可以使用chrome的redux插件调试：

<img src="https://github.com/hcnode/koa-cola/raw/master/screenshots/dev-tool.png" alt="Drawing" width="600"/>
