---
title: Feign传参与Spring MVC的一些区别
date: 2019-08-05
categories:
- 技术
- spring cloud
tags:
- spring
- spring cloud
- open feign
---

## OpenFeign 为什么要和 Spring MVC 传参比较
当我们开发 `spring cloud` 项目时，大部分使用openFeign作为网络请求客户端。而openFeign使用的注解都是使用的 `spring MVC` 的注解，这极大的降低了学习成本，但是 `OpenFeign` 又和 `spring MVC` 的请求又有诸多不同。在降低了学习成本的同时，带来了一些困扰。当我们理所应当的使用 `spring MVC` 传递参数时，`OpenFein` 却不一定理睬我们。这篇文章的主要目标就是理清楚 `OpenFeign` 传参时区别于 `spring MVC` 的地方，让我们能更好的使用 `OpenFeign`

## Feign传参与Spring MVC的一些区别
### 1 时间参数
当参数为时间，不能使用 `@RequestParam("paymentDate") Date paymentDate` 传递
```java
@PostMapping(value = "/updateGroupPurchaseInfo")
void updateGroupPurchaseInfo(@RequestParam("orderId") Long orderId, @RequestParam("paymentDate") Date paymentDate);
```

正确的是将时间包裹在对象中
```java
@PostMapping(value = "/updateGroupPurchaseInfo")
void updateGroupPurchaseInfo(@RequestBody UpdateGroupPurchaseInfoReqDTO updateGroupPurchaseInfoReqDTO);
```

### 2 集合List Set
集合 `List`, `Set` 等作为方法参数时，必须指定实例类型（例如：`ArrayList`），不能用接口类型(例如: `List`)，用数组也可以

### Map
不能传递复杂的 `Map` 类型，比如map里包含 `Map` （例如：`Map<key, Map>`）

### @RequestBody 注解
参数为 `@RequestBody` 时，实现必须加 `@RequestBody` ,否则参数为 `null`

### @RequestParam 注解
参数为 `@RequestParam` 时，必须指定参数名称，即使 `@RequestParam("orderId")` 与对象的名称一致。
当注解为` @RequestParam("orderId") Long oid`, 注解名称与参数名称不一致时，实现方法也必须添加 `@RequestParam("orderId")`

### @PathVariable 注解
参数为 `@PathVariable` 时，必须指定参数名称 接口和接口的实现方法必须都加注解。 例如：`@PathVariable("zoneId") Integer zoneId`
