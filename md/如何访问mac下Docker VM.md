---
title: 如何访问Mac下Docker VM
date: 2018-05-29
categories:
- 技术
- docker
tags:
- docker
- vm
- mac
---

## 为什么
Mac 系统下的Docker并不是直接安装在mac系统中的，而是安装在虚拟机中的
，所以很多需要操作挂载文件夹的时候非常头疼。

## 访问Docker所在虚拟机

```bash
# 进入docker所在虚拟机
screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty
# dcoker 目录
ls -l /var/lib/docker
```



