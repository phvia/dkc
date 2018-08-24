# mysql

注意当前使用的配置文件是 `mysql.conf.d/mysqld.cnf`.

修改了 server 和 client 的字符集为 utf8，修改了 timezone 为 '+8:00'，验证方式如下：
```
查看字符集：进入数据库然后输入 \s
查看时区：进入数据库然后输入 SELECT @@global.time_zone 或者执行 select now();
```

所有 Server System Variables 见 `https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html`

`config.d/` 目前没有用到，对应容器中的配置内容，如果需要变更并使用，则加入到 volume 中.
