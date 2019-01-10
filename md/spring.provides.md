---
title: spring.provides
date: 201-01-10
categories:
- 技术
- java
tags:
- srping boot
- starter
---

## Remove spring.provides files

It does use pom parsing indirectly, since aether parses the poms. The info may look like its duplicating information but it isn't exactly. The provides is used to resolve ambiguity. Basically if a provides file says that a 'starter S provides X'... then 'S' takes priority over other things that also provide it.

It is surprising how many things end up multiple times in the dependency graph reachable from severral different things. The provides files were added to avoid some surprising/unwanted suggestions. Think of the provides file as a very strong hint to the ide that a boot developer thought 'if I want to add X to my pom, you should use starter S'. The dependencies inferred from pom are often just accidental and not as 'deliberate'. (Heuristics like dependency's depth in the graph were explored but didn't provide good results).

@dsyer helped with populating the provides files. This was a long time ago and i'm not sure if it has been kept up to date, so the quality of the info in the various provides file may not be as good/complete as it once was. It has also been a bit of a controversial feature. I'm sure a few people like it, but there's also a lot of folks who have asked how to turn it of.



具体详见 https://github.com/spring-projects/spring-boot/issues/12435

[Stop relying on spring.provides files before Spring Boot 2.1 is GA](https://github.com/spring-projects/spring-ide/issues/251)
spring boot 2.1 GA 后不再依赖 spring.provides


