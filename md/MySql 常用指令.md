title: MySql 常用指令
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

### 刷新权限

`flush privileges;`


