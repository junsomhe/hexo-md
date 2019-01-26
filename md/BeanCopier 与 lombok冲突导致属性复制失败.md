---
title: BeanCopier 与 lombok冲突导致属性复制失败
date: 2019-01-26
categories:
- 技术
- java
tags:
- BeanCopier
- lombok
- @Accessors(chain = true)
---

## 缘由
一直用BeanCopier进行属性复制，非常好用。最近又经常使用lombok简化代码，当我使用 `@Accessors(chain = true)` 进行链式set时发现复制的值
都是null的。

## 推测原因
`@Accessors(chain = true)` 的作用是将 `setter` 方法的返回值由 `void` 修改为 `this`。 这导致 `setter` 的方法签名改变，最终导致
 `BeanCopier` 无法识别现有的 `setter` 方法。
 
 ## 解决方案
 
 - 去除 `@Accessors(chain = true)` 注解
 - 不使用 `BeanCopier`， 使用 `org.springframework.beans.BeanUtils`

