---
title: Gradle 上传jar包到仓库.md
date: 2018-07-20
categories:
- 技术
- gradle
tags:
- gradle
- publish
- maven
---

## 引入插件
首先在`build.gradle`中引入`maven-publish`插件
```dtd
apply plugin: "maven-publish"
```

## 设置一些必要的参数
```dtd
//设置动态属性
ext {
    //发布到仓库用户名
    publishUserName = "adjunsommin"
    //发布到仓库地址
    publishUserPassword = "pwssword"
    //仓库地址
    publishURL = "http://maven.junsom.com/repository/junsom-release/"
    
    apiBaseJarName = "junsom-some-code"
    apiBaseJarVersion = '0.0.1'
    builtBy = "gradle 4.8"
}
```

## 打包class文件

```dtd
//jar包名称组成：[baseName]-[appendix]-[version]-[classifier].[extension]
//打包class文件
task apiBaseJar(type: Jar) {
    version apiBaseJarVersion
    baseName apiBaseJarName
    from sourceSets.main.output
    destinationDir file("$buildDir/api-libs")
    includes ['com/junsom/**']
    manifest {
        attributes 'packageName': apiBaseJarName, 'Built-By': builtBy, 'Built-date': new Date().format('yyyy-MM-dd HH:mm:ss'), 'Manifest-Version': version
    }
}
```

## 打包源文件
```dtd
//打包源码
task apiBaseSourceJar(type: Jar) {
    version apiBaseJarVersion
    baseName apiBaseJarName
    classifier "sources"
    from sourceSets.main.allSource
    destinationDir file("$buildDir/api-libs")
    includes ['com/junsom/**']
    manifest {
    attributes 'packageName': apiBaseJarName + '-sources', 'Built-By': builtBy, 'Built-date': new Date().format('yyyy-MM-dd HH:mm:ss'), 'Manifest-Version': version
    }
}
```

### 上传到maven仓库
配置上传的maven仓库
```dtd
//上传jar包
publishing {
    publications {
        mavenJava(MavenPublication) {
            groupId 'com.wenfex.xybb'
            artifactId apiBaseJarName
            version apiBaseJarVersion
            from components.java
            artifacts = [apiBaseJar, apiBaseSourceJar]
        }
    }
    repositories {
        maven {
            url publishURL
            credentials {
                username = publishUserName
                password = publishUserPassword
            }
        }
    }
}
```
执行指令，先查询上传可用指令

```bash
junsoms-MacBook-Pro-2:chain-eos junsom$ gradle tasks
Starting a Gradle Daemon (subsequent builds will be faster)
......

Publishing tasks
----------------
generatePomFileForMavenJavaPublication - Generates the Maven POM file for publication 'mavenJava'.
publish - Publishes all publications produced by this project.
publishMavenJavaPublicationToMavenLocal - Publishes Maven publication 'mavenJava' to the local Maven repository.
publishMavenJavaPublicationToMavenRepository - Publishes Maven publication 'mavenJava' to Maven repository 'maven'.
publishToMavenLocal - Publishes all Maven publications produced by this project to the local Maven cache.

......

```
指令中有各种上传方式，我们直接用简单的`publish`指令就ok了。
```bash
junsoms-MacBook-Pro-2:chain-eos junsom$ gradle publish
Upload http://maven.xiangyingbaobao.com/repository/xybb-release/com/bogu/chain-eos/0.0.1/chain-eos-0.0.1.jar
Upload http://maven.xiangyingbaobao.com/repository/xybb-release/com/bogu/chain-eos/0.0.1/chain-eos-0.0.1.jar.sha1
Upload http://maven.xiangyingbaobao.com/repository/xybb-release/com/bogu/chain-eos/0.0.1/chain-eos-0.0.1.jar.md5
Upload http://maven.xiangyingbaobao.com/repository/xybb-release/com/bogu/chain-eos/0.0.1/chain-eos-0.0.1.pom
Upload http://maven.xiangyingbaobao.com/repository/xybb-release/com/bogu/chain-eos/0.0.1/chain-eos-0.0.1.pom.sha1
Upload http://maven.xiangyingbaobao.com/repository/xybb-release/com/bogu/chain-eos/0.0.1/chain-eos-0.0.1.pom.md5
Upload http://maven.xiangyingbaobao.com/repository/xybb-release/com/bogu/chain-eos/0.0.1/chain-eos-0.0.1-sources.jar
Upload http://maven.xiangyingbaobao.com/repository/xybb-release/com/bogu/chain-eos/0.0.1/chain-eos-0.0.1-sources.jar.sha1
Upload http://maven.xiangyingbaobao.com/repository/xybb-release/com/bogu/chain-eos/0.0.1/chain-eos-0.0.1-sources.jar.md5
Could not find metadata com.bogu:chain-eos/maven-metadata.xml in remote (http://maven.xiangyingbaobao.com/repository/xybb-release/)
Upload http://maven.xiangyingbaobao.com/repository/xybb-release/com/bogu/chain-eos/maven-metadata.xml
Upload http://maven.xiangyingbaobao.com/repository/xybb-release/com/bogu/chain-eos/maven-metadata.xml.sha1
Upload http://maven.xiangyingbaobao.com/repository/xybb-release/com/bogu/chain-eos/maven-metadata.xml.md5

BUILD SUCCESSFUL in 12s
6 actionable tasks: 6 executed

```
以上，jar包就上传到自家maven仓库了。

## 全部代码

```dtd
apply plugin: "maven-publish"

//设置动态属性
ext {
    //发布到仓库用户名
    publishUserName = "adjunsommin"
    //发布到仓库地址
    publishUserPassword = "pwssword"
    //仓库地址
    publishURL = "http://maven.junsom.com/repository/junsom-release/"

    apiBaseJarName = "junsom-some-code"
    apiBaseJarVersion = '0.0.1'
    builtBy = "gradle 4.8"
}

//jar包名称组成：[baseName]-[appendix]-[version]-[classifier].[extension]
//打包class文件
task apiBaseJar(type: Jar) {
    version apiBaseJarVersion
    baseName apiBaseJarName
    from sourceSets.main.output
    destinationDir file("$buildDir/api-libs")
    includes ['com/junsom/**']
    manifest {
        attributes 'packageName': apiBaseJarName, 'Built-By': builtBy, 'Built-date': new Date().format('yyyy-MM-dd HH:mm:ss'), 'Manifest-Version': version
    }
}
//打包源码
task apiBaseSourceJar(type: Jar) {
    version apiBaseJarVersion
    baseName apiBaseJarName
    classifier "sources"
    from sourceSets.main.allSource
    destinationDir file("$buildDir/api-libs")
    includes ['com/junsom/**']
    manifest {
        attributes 'packageName': apiBaseJarName + '-sources', 'Built-By': builtBy, 'Built-date': new Date().format('yyyy-MM-dd HH:mm:ss'), 'Manifest-Version': version
    }
}

//上传jar包
publishing {
    publications {
        mavenJava(MavenPublication) {
            groupId 'com.wenfex.xybb'
            artifactId apiBaseJarName
            version apiBaseJarVersion
            from components.java
            artifacts = [apiBaseJar, apiBaseSourceJar]
        }
    }
    repositories {
        maven {
            url publishURL
            credentials {
                username = publishUserName
                password = publishUserPassword
            }
        }
    }
}
```

