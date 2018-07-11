# redis

## 配置文件 redis.conf

有修改的配置项
```
appendonly yes
```

当然，你可以选择匹配所使用 redis 版本的 redis.conf，并修改配置项来构建镜像，例如：
```
wget https://raw.githubusercontent.com/antirez/redis/3.2.12/redis.conf
```

## 持久化存储

Redis 默认的 volume 映射规则是：主机 `/var/lib/docker/volumes/` 的匿名 volume 映射到容器中 `/data/`。

要进入容器可以执行 `docker-compose exec redis bash`


