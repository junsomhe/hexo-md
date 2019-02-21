---
title: 时间不一致导致的 Turbine 无法获取实例hystrix.stream
date: 2019-02-21
categories:
- 技术
- java
tags:
- spring cloud
- hystrix
- trubine
---

## 为什么使用 Turbine
使用 `turbine` 是用来分布式环境下统一服务的各个实例的hystrix信息。

## 一种特殊的导致 Turbine 无法获取实例 hystrix.stream 数据
turbine 服务器会抛弃过时的数据。当服务器时间不一致时，你的数据可能永远属于过时数据，所以你的 turbine 永远拿不到数据。

### 如何解决这种异常
- 同步时间。最简单实用的处理方法
- 添加 `turbine.InstanceMonitor.eventStream.skipLineLogic.enabled=false` 到你的 `application.yml` 或 `application.properties`

## 参考
https://github.com/spring-cloud/spring-cloud-netflix/issues/820
https://stackoverflow.com/questions/28973994/spring-cloud-turbine-empty-stream


