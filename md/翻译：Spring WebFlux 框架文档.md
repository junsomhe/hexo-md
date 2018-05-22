title: 翻译：Spring WebFlux 框架文档.md
date: 2018-03-30
categories:
- 技术
- spring
tags:
- spring
- WebFlux
---

## 6.1. 介绍
### 6.1.1 什么是反应式程序设计
简单的讲反应式程序设计是一个基于异步和事件驱动，只需要少量的线程垂直缩放而不是水平缩放的非阻塞式应用程序。

反应式程序设计的一个关键点是负压（反压），它是一个确保生产者不会压倒消费者的机制。举个例子，如果数据库拥有反应式扩展组件，当网络连接速度
过慢时，数据库也可以降低数据发送或者暂停直到网络恢复正常。

反应式程序设计引导从命令式到逻辑的陈述式异步构成的重大转变。这相当编写阻塞式代码与使用Java 8 的`CompletableFuture`通过lambda表达式
编写代码。

更多的介绍请看`Dave Syer`的系列博客 "Notes on Reactive Programming". https://spring.io/blog/2016/06/07/notes-on-reactive-programming-part-i-the-reactive-landscape

### 6.1.2. Reactive API and Building Blocks
