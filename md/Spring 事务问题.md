---
title: Spring boot 事务问题
date: 2019-04-19
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

### 在同一个 `@Service` 注解下的不同 `@Transactional` 不能同时生效
这是spring 事务的奇怪特性。比如我要在 `catch` 里执行一些事务方法（关闭订单等。），我需要使用 `@Transactional(propagation = Propagation.REQUIRES_NEW)` 开启一个独立事务，避免被主事务回滚。然而，不行！至少你不能写在同一个 `Class` 类里。你必须在另一个 `Class` 里的方法加入 `@Transactional(propagation = Propagation.REQUIRES_NEW)` 才能生效。