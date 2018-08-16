---
title: EOS 常见错误
date: 2018-07-16
categories:
- 技术
- eos
tags:
- eos
- 常见错误
---

### EOS Docker启动后无法执行指令
原因：eos最新版本`v1.0.9`出现的问题，现阶段使用`v1.0.2`版本就行了，EOS文档版本还是 `v1.0.0`。

```bash
root@51c1413b8d66:~/eosio-wallet# cleos wallet list
"/opt/eosio/bin/keosd" launched
Wallets:
1629382ms thread-0   main.cpp:2756                 main                 ] Failed with error: Assert Exception (10)
response_content_length >= 0: Invalid content-length response
```

### EOS CPU资源用尽

`Error 3080004: Transaction exceeded the current CPU usage limit imposed on the transaction`

抵押EOS换取cpu就是了

```bash
system delegatebw itleakstoken tokenitleaks "2.0000 EOS" "2.000 EOS" -p itleakstoken
```