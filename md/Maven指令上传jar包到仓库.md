title: Maven指令上传jar包到仓库
date: 2018-03-22
categories:
- 技术
- java
tags:
- maven mvn 上传jar包到仓库
---

## mvn指令
```bash
mvn deploy:deploy-file -DgroupId=xxx.xxx -DartifactId=xxx -Dversion=0.0.2 -Dpackaging=jar -Dfile=D:\xxx.jar -Durl=http://xxx.xxx.xxx.xxx:8081/repository/3rdParty/ -DrepositoryId=3rdParty
```
- -DgroupId `groupId`
- -DartifactId `artifactId`
- -Dversion `version`
- -Dpackaging 包类型 `jar` 或 `war`
- -Dfile 包本地路径
- -Durl 仓库地址
- -DrepositoryId 仓库名称