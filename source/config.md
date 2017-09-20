---
layout: default
id: config
title: config
prev: api-responses.html
next: config-env.html
---

通过约定config目录下所有文件都会成为config的属性，运行时会被env环境下的配置覆盖，所有配置在app.config。

	> config
	    > env
            local.js
            test.js
            development.js
        development.js
        production.js
        any_config_you_need.js 
        ...

比如配置any_config_you_need.js 

    exports.module = {
        foo : 'bar'
    }


如果当前是development环境，并且config/env/development.js:

    exports.module = {
        foo : 'wow'
    }

那么`app.config.foo == 'wow'`