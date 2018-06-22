title: Linux 常用指令
date: 2017-05-13
categories:
- 技术
- linux
tags:
- Linux 常用指令
---

## linux之间传输文件
```bash
scp -r /home/wwwroot/www/charts/util
\ root@192.168.1.65:/home/wwwroot/limesurvey_back/scp
```

## 查看端口占用
`netstat -anp | grep 80`

## 开机启动 systemctl
`systemctl enable mariadb.service`
`mariadb.service` 换成你需要开机启动的服务即可。