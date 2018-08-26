# mysql

mysqld.cnf 修改项如下：
```
# 开启 binary log 日志
# https://dev.mysql.com/doc/refman/5.7/en/replication-options-binary-log.html
log_bin=mysql-bin
server_id=1
port=3306

# 开启慢查询
# https://dev.mysql.com/doc/refman/5.7/en/slow-query-log.html
slow_query_log=1
slow_query_log_file=slow_query.log
long_query_time=10

# 错误日志
log-error = /var/log/mysql/error.log

# 单条行数据的大小限制，系统默认是4M，slave_max_allowed_packet 默认是1G.
# https://dev.mysql.com/doc/refman/5.7/en/replication-features-max-allowed-packet.html
# https://dev.mysql.com/doc/refman/5.7/en/replication-options-slave.html
max_allowed_packet=32M

# 服务器字符集
# https://dev.mysql.com/doc/refman/5.7/en/charset-server.html
character-set-server=utf8

# 时区
# https://dev.mysql.com/doc/refman/5.7/en/time-zone-support.html
default-time-zone='+8:00'
```

`dkc restart mysql 使生效`

## FAQ

### 查看服务器系统变量.
---
```
查看log_bin: show variables like '%bin%';
查看slow_query_log: show variables like '%query%';
查看log_error: show variables like '%error%';
查看字符集: \s 或 show variables like 'char%';
查看时区: show variables like 'time_zone' 或 select now() 查看时间
```

所有 Server System Variables 见 `https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html`

### 字符集设为utf8的具体配置.
---
```
[mysqld]
# 服务端字符集
character-set-server=utf8

[mysql]
# 客户端字符集
default-character-set=utf8

[client]
# 客户端字符集
default-character-set=utf8
```

### 查看和更改某个库的当前字符集.
---
```
@guide https://dev.mysql.com/doc/refman/5.6/en/charset-database.html

# 查看指定库的字符集
mysql> show create database db_name;

# 修改库的字符集
mysql> alter database db_name character set utf8 [collate utf8_unicode_ci];
```

