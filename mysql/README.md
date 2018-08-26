# mysql

注意当前使用的配置文件是 `mysql.conf.d/mysqld.cnf`.

修改了 server 和 client 的字符集为 utf8, 修改了 timezone 为 '+8:00' 同 PRC 效果一样，验证方式如下：
```
查看字符集：进入数据库然后输入 \s 或者 show variables like 'char%';
查看时区：进入数据库然后输入 show variables like 'time_zone'; 或者执行 select now() 查看时间;
```

所有 Server System Variables 见 `https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html`

## FAQ

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

### 如果查看和更改某个库的当前字符集.
---
```
@guide https://dev.mysql.com/doc/refman/5.6/en/charset-database.html

# 查看指定库的字符集
mysql> show create database db_name;

# 修改库的字符集
mysql> alter database db_name character set utf8 [collate utf8_unicode_ci];
```

