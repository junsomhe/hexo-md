---
title: git恢复误删文件.md
date: 2018-12-7
categories:
- 技术
- git
tags:
- git
- 恢复
- 误删
---

## git恢复远程误删除文件

将本地分支 `checkout`到删除文件前的版本
```bash
git checkout 7120159d728a62bccfb9896a23c9aabe0947f81e
```

找到删除的文件拷贝出来，切换回主分支，复制进去就ok。