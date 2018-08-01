# redis

## 配置文件 redis.conf

当然，你可以选择匹配所使用 redis 版本的 redis.conf，并修改配置项来构建镜像，例如：
```
wget https://raw.githubusercontent.com/antirez/redis/3.2.12/redis.conf
```

由于配置文件是 COPY 进容器的，所以修改了配置文件需要运行 `dkc up --build -d` 重新构建。

## 持久化存储

Redis 默认的 volume 映射规则是：主机 `/var/lib/docker/volumes/` 的匿名 volume 映射到容器中 `/data/`。

要进入容器可以执行 `docker-compose exec redis bash`


## 如何允许远程登录

1.修改配置文件
```
# 注释掉 bind 行
# bind 127.0.0.1

# 保护模式设置为关闭
protected-mode = no

# 设一个登录密码
requirepass foobared
```

2.登录
```
redis-cli -h xxx.xx.xx.xx [-p 6379] -a foobared
```

