---
title: Spring boot 事务问题
date: 2019-08-13
categories:
- 技术
- spring boot
tags:
- spring
- spring boot
- Transactional
---

## `Spring boot` 的事务
`Spring boot` 的事务一直表现一些奇怪的特点，现在一一列举一下，留作参照。

### 事务 `@Transactional` 注解不生效
事务不生效的原因有很多，其他的都可以理解，但有一个确实不可理喻。当 `@Service` 第一个方法没有使用 `@Transactional` 注解时，后续调用的方法即使使用 `@Transactional` 注解。事务也不会开启。

### 在同一个 `@Service` 注解类下的不同 `@Transactional` 不能同时生效
这是spring 事务的奇怪特性。比如我要在 `catch` 里执行一些事务方法（关闭订单等。），我需要使用 `@Transactional(propagation = Propagation.REQUIRES_NEW)` 开启一个独立事务，避免被主事务回滚。然而，不行！至少你不能写在同一个 `Class` 类里。你必须在另一个 `Class` 里的方法加入 `@Transactional(propagation = Propagation.REQUIRES_NEW)` 才能生效。
原因：同一个类的的方法调用不是使用spring的代理调用，而是类似于 `this.xxx`, 这个是类方法本身的调用无法使用事务aop

### 不同 `@Service` 注解的类的 `@Transactional` 生效区别
1，主类没有事务注解，被调用类有事务注解，事务生效。
2，主类有事务注解，被调用类有事务注解，事务生效。

### 结论
1，避免在需要开启事务的方法被不需要开启事务的同一个类的方法所调用，否则事务无效。
2，避免需要开启新事务的方法被同一个类的方法所调用，否则事务无效。
总结来说，避免非spring代理方法调用，否则无法开始spring aop事务。

