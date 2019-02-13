---
title: 非root用户运行docker命令
date: 2019-02-13
categories:
- 技术
- docker
tags:
- docker
- 非root
---

## docker 安全策略
由于 `docker`安全策略，运行 `docker ps` 等命令需要 `root` 权限。而一般情况下，操作的都是非 `root` 用户，导致使用时需要加 `sudo`，非常不方便。

## 使用非 root 用户运行 docker 命令
### 添加 docker group
```bash
sudo groupadd docker
```

### 将用户加入 docker group 内
`${USER}` 是你想运行 `docker` 命令的用户名称 
```bash
sudo gpasswd -a ${USER} docker
```

### 重启 docker

```bash
sudo systemctl restart docker
```

### 切换当前会话到新 group 或者重启 X 会话 
这一步是必须的，否则因为 groups 命令获取到的是缓存的组信息，刚添加的组信息未能生效，所以 docker images 执行时同样有错。

```bash
newgrp - docker
```


