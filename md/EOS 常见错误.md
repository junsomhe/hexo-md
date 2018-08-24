---
title: EOS 常见错误
date: 2018-08-24
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

### EOS docker容器自动关闭

docker中eos运行久了会自动关闭，并报如下错误
```bash
2018-08-22T13:29:57.594 thread-0   chain_plugin.cpp:853          log_guard_exception  ] Database has reached an unsafe level of usage, shutting down to avoid corrupting the database.  Please increase the value set for "chain-state-db-size-mb" and restart the process!
2018-08-22T13:29:57.594 thread-0   chain_plugin.cpp:859          log_guard_exception  ] Details: 3060101 database_guard_exception: Database usage is at unsafe levels
database free: 134209840, guard size: 134217728
    {"f":134209840,"g":134217728}
    thread-0  controller.cpp:1623 validate_db_available_size
```

查看eos chain_plugin 文档发现如下指令
```bash
  --chain-state-db-size-mb arg (=1024)  Maximum size (in MiB) of the chain
                                        state database
  --chain-state-db-guard-size-mb arg (=128)
                                        Safely shut down node when free space
                                        remaining in the chain state database
                                        drops below this size (in MiB).
```

第一个指令是控制链数据库的大小 默认是1024MB。第二个指令是链数据库容量小于多少时自动关闭节点，默认是128MB。

很显然长期运行eosio容器，导致数据库容量不足，自动关闭节点了。

