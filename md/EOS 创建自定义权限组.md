---
title: EOS 创建自定义权限组
date: 2018-05-28
categories:
- 技术
- eos
tags:
- eos
- 自定义权限
---

## EOS 权限
eos默认权限只有`owner`和`active`。一般情况下这些权限是不够用的，还好eos支持自定义权限。

eos github上的wiki文档并没有给出创建自定义权限的命令行例子，所以我这里blog记录下。

## 创建自定义权限
```bash
cleos set account permission testera data.rss 
\'{"threshold":1,"keys":[],"accounts":[{"permission":{"actor":"tester1a","permission":"active"},"weight":1},{"permission":{"actor":"tester2a","permission":"active"},"weight":50}],"permissions":[{"perm_name":"data.rss","parent":"active"}]}' active
```

结果如下
```bash
root@7f102c713d06:/# cleos  get account testera
privileged: false
permissions: 
     owner     1:    1 EOS8f1ThHdG9EY1i5uj8AZbagfwCTipWFkp5NUMDTFmYoXazPLg41
        active     1:    1 tester1a@active, 50 tester2a@active, 
           data.rss     1:    1 tester1a@active, 50 tester2a@active, 
           datarss     1:    1 tester1a@active, 50 tester2a@active, 
memory: 
     quota:        -1 bytes  used:     3.361 Kb   

net bandwidth: (averaged over 3 days)
     used:                -1 bytes
     available:           -1 bytes
     limit:               -1 bytes

cpu bandwidth: (averaged over 3 days)
     used:                -1 us   
     available:           -1 us   
     limit:               -1 us 
```

## 删除权限
```bash
cleos set account permission testera data.rsst 'NULL' active
```

## 扩展
Shell 中的`"permissions":[{"perm_name":"data.rss","parent":"active"}]`这部分代码其实可以省略。省略后指令和修改权限已经没什么区别了，所以其实并不存在所谓创建权限，只要修改权限时赋值的权限不存在，自动会创建此权限。
