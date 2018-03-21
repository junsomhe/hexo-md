title: java 远程调试
date: 2018-03-22
categories:
- 技术
- java
tags:
- spring boot
- java
- 远程调试
- idea
- eclipse
---

> 本博客引用自http://blog.csdn.net/wo541075754/article/details/75008617.
> 作者: 丑胖侠

## java远程调试参数
address不能与`server.port`相同

```java
-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005
```

## Intellij IDEA远程调试配置
参考 http://blog.csdn.net/wo541075754/article/details/75008617.

## Eclispe远程调试配置

