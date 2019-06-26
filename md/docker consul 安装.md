---
title: docker consul 安装
date: 2019-06-26
categories:
- 技术
- docker
- consul
tags:
- consul安装
---

## 下载 consul 镜像
```shell
[mkstar@chdlxt214 ~]$ docker pull consul
Using default tag: latest
Trying to pull repository docker.io/library/consul ...
latest: Pulling from docker.io/library/consul
e7c96db7181b: Pull complete
86b1a60a2bea: Pull complete
2392e3d27776: Pull complete
565cd9d57cb0: Pull complete
ac738aa67e22: Pull complete
0c0298519820: Pull complete
Digest: sha256:2ec19048abef7ff163206d7cd30147e6b2e5b73f260c2c6e4d092e648d4f68bc
Status: Downloaded newer image for docker.io/consul:latest
```

## 启动三个server容器

server-01
```shell
docker run -itd --name mk-cserver-01 --restart=always -p 8500:8500 consul agent -ui -bootstrap-expect=3 -server -client=0.0.0.0
```

server-02
```shell
docker run -itd --name mk-cserver-02 --restart=always -p 8501:8500 consul agent -bootstrap-expect=3 -server -retry-join=172.17.0.2
```

server-03
```shell
docker run -itd --name mk-cserver-03 --restart=always -p 8502:8500 consul agent -bootstrap-expect=3 -server -retry-join=172.17.0.2
```
这里需要注意的是只有`server-01`指定了`-ui`和`-client=0.0.0.0`，说明只有`server-01`提供了外部可访问的ui和ip地址

`server-02`和`server-03`指定了`-retry-join=172.17.0.2`，目的是为了加入`server-01`集群。`172.17.0.2`是`server-01`在`docker`中的ip值。

## 启动一个客户端容器
```shell
docker run -itd --name mk-cclient-01 --restart=always -p 8550:8500 consul agent -ui -client=0.0.0.0  -retry-join=172.17.0.2
```

这里需要特别注意的是客户端移除了`-server`和`-bootstrap-expect=3`指令
