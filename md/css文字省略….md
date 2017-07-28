---
title: css文字省略…
categories:
- 技术
- css
tags:
- css文字省略
---

## 单行文字实现2:

``` css
text-overflow: ellipsis;
overflow: hidden;
white-space: nowrap;
```
## 多行文字实现(有浏览器兼容问题):

``` css
overflow: hidden;
-webkit-line-clamp: 3; 
-webkit-box-orient: vertical;
display: -webkit-box;
```
