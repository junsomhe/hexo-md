title: MySql 常用指令
date: 2017-05-13
categories:
- 技术
- mysql
tags:
- MySql 常用指令
---
### 免密码登录

在`/etc/my.cnf`中的`[mysqld]`部分添加`skip-grant-tables`

### 修改密码

`skip-grant-tables`环境下无效

`set password for 用户名@localhost = password('新密码');`

`skip-grant-tables`环境下有效

`update mysql.user set Password=password('密码') where User='用户名';`

### 创建用户

`CREATE USER '用户名'@'%' IDENTIFIED BY '密码';`

### 授权

`grant all privileges on *.* to 'root'@'%';`

### 撤销授权

`revoke all on *.* from dba@localhost;`

### 显示用户权限

`show grants for 'root'@'%';`

### 刷新权限

`flush privileges;`

### 权限列表
- Alter         修改表和索引
- Create        创建数据库和表
- Delete        删除表中已有的记录
- Drop          抛弃（删除）数据库和表
- INDEX         创建或抛弃索引
- Insert        向表中插入新行
- REFERENCE     未用
- Select        检索表中的记录
- Update        修改现存表记录
- FILE          读或写服务器上的文件
- PROCESS       查看服务器中执行的线程信息或杀死线程
- RELOAD        重载授权表或清空日志、主机缓存或表缓存。
- SHUTDOWN      关闭服务器
- ALL           所有；ALLPRIVILEGES同义词
- USAGE         特殊的“无权限”权限



