title: MySQL配置max_connections无效
date: 2017-08-28
categories:
- 技术
- mysql
tags:
- MySql max_connections mariadb
---
## my.cnf中max_connections不生效

在使用mariadb时, 我们总会报'too_many_connections'错误.
理论上只要在`/etc/my.cnf`中配置`max_connections=3000`,然后重启maridb就ok了.然而事实是**不生效**.

翻找了很多贴子, 大致意思是最大连接数受到`/etc/security/limits.conf`中linux mysql用户配置的影响,要解决这个问题需要2步操作

### 配置limits.conf

打开 `/etc/security/limits.conf`, 添加mysql用户配置
```xml
mysql hard nofile 65535
mysql soft nofile 65535
```
### 配置mariadb.service
打开 `/usr/lib/systemd/system/mariadb.service`, mysql是`mysqld.service`
```xml
LimitNOFILE=65535
```

### 重启mariadb
重启mariadb, `my.cnf`中的 `max_connections`就会生效

