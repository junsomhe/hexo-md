---
title: maven mvnw支持
date: 2018-12-13
categories:
- 技术
- maven
tags:
- maven
- mvnw
- wrapper
---

## mvnw是什么（Maven Wrapper/Maven保持构建工具版本一直的工具）

Maven是一款非常流行的Java项目构建软件，它集项目的依赖管理、测试用例运行、打包、构件管理于一身，是我们工作的好帮手，maven飞速发展，它的发行版本也越来越多，如果我们的项目是基于Maven构件的，那么如何保证拿到我们项目源码的同事的Maven版本和我们开发时的版本一致呢，可能你认为很简单，一个公司嘛，规定所有的同事都用一个Maven版本不就万事大吉了吗？一个组织内部这是可行的，要是你开源了一个项目呢？如何保证你使用的Maven的版本和下载你源码的人的Maven的版本一致呢，这时候mvnw就大显身手了

### 在Pom.Xml中添加Plugin声明

```xml
<plugin>
    <groupId>com.rimerosolutions.maven.plugins</groupId>
    <artifactId>wrapper-maven-plugin</artifactId>
    <version>0.0.4</version>
</plugin>
```
这样当我们执行mvn wrapper:wrapper 时，会帮我们生成mvnw.bat、mvnw、maven/maven-wrapper.jar、maven/maven-wrapper.properties这些文件。

然后我们就可以使用mvnw代替mvn命令执行所有的maven命令，比如mvnw clean package

### 直接执行Goal（推荐使用这种）

mvn -N io.takari:maven:wrapper -Dmaven=3.5.4表示我们期望使用的Maven的版本为3.5.4

产生的内容和第一种方式是一样的，只是目录结构不一样，maven-wrapper.jar和maven-wrapper.properties在".mvn/wrapper"目录下
