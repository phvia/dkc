# dkc

使用 docker-compose 加速构建你的PHP环境.

----- dkc 在此作为 docker-compose 的缩写，你可以理解为 `alias dkc=docker-compose`


## 安装 docker

From repository
```
wget https://raw.githubusercontent.com/farwish/delicateShell/master/support/installDockerCE.sh && chmod +x installDockerCE.sh && ./installDockerCE.sh && rm -f installDockerCE.sh
```
https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository  

Or from package

https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-from-a-package  


## 安装 docker-compose

https://docs.docker.com/compose/install/#install-compose


## 几个平常可能使用的脚本

* ./compose_remove_all_container.sh # 停止并移除docker-compose启动的容器
* ./remove_none_name_images.sh # 移除名称为 <none> (即没有名称)的镜像
* ./start_all_container.sh # 使用 `docker` 命令逐个启动所有容器
* ./stop_and_remove_all_container.sh # 使用 `docker` 命令逐个停止并删除所有容器


## 网站项目目录

默认您的网站项目代码放置于 `web/`，当然你可以修改 `docker-compose.yml` 中 volume 的映射关系，然后你可以放置在任何地方。


## 指南

### 如何启动所有服务

修改 `docker-composer.yml` volume 配置项中 `dkc/` 在你主机上的正确路径，然后启动所有：
```
docker-compose up --build [-d]
```


### 解决Redis的四个WARNING

1.no config file specified, using the default config.

默认已通过在 `docker-compose.yml` 中配置 volume 使用配置文件 `redis/redis.conf` 解除了 WARNING，详细见子目录内 README.md，你可以修改 `redis/redis.conf` 的配置项满足你的需要。

2.The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.

默认已通过在 `docker-compose.yml` 中配置 sysctls 的选项解除了 WARNING。

3.vm.overcommit_memory is set to 0!

需要你切换至 root，然后按如下设置：
```
$ echo vm.overcommit_memory = 1 >> /etc/sysctl.conf
$ sysctl vm.overcommit_memory=1
```

4.you have Transparent Huge Pages (THP) support enabled in your kernel.

需要你切换至 root，然后按如下设置：
```
$ echo 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' >> /etc/rc.local
$ source /etc/rc.local
```


### 如何运行Nginx静态站点

```
# 修改你的 web/ 目录位于主机内的绝对路径.

$ vi docker-compose.yml

- "/path/to/dkc/web:/usr/share/nginx/html"
```

```
# 启动 nginx 服务，及其常用操作

$ docker-compose up -d nginx
$
$ docker-compose stop nginx
$ docker-compose ps
$ docker-compose logs -f --tail 10 nginx
$ docker-compose exec nginx /bin/bash
```

现在可以在浏览器中访问: http://ip


### PHP服务

关键之处在于 nginx 配置中要指明 PHP 后端服务的地址: `fastcgi_pass   php-address:9000;`

而 php-address 是在 nginx 服务中配置的 --links 项。

现在可以在浏览器中访问: http://ip/phpinfo.php


### MySQL服务

```
# 启动 MySQL 服务，及其常用操作

$ docker-compose up -d mysql
$ docker logs mysql-con
$ docker-compose exec mysql bash  # equals to: docker exec -it mysql-con bash
$ mysql -uroot -p
```

使用自定义的 MySQL 配置文件，例如
```
The default configuration for MySQL can be found in /etc/mysql/my.cnf  
$ docker run --name mysql-con -v /my/custom:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=123456 -d mysql-img-farwish:v1
```

把敏感配置值放在文件中，例如
```
docker run --name mysql-con -e MYSQL_ROOT_PASSWORD_FILE=/run/secrets/mysql-root -d mysql-img-farwish:v1

目前官方镜像只支持 MYSQL_ROOT_PASSWORD, MYSQL_ROOT_HOST, MYSQL_DATABASE, MYSQL_USER, and MYSQL_PASSWORD.
```

Dump 数据库到宿主机，例如
```
docker exec mysql-con sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /home/ubuntu/all-databases.sql
```

使用一个已存在的数据库
```
如果启动MySQL容器时带上一个包含数据库的目录，$MYSQL_ROOT_PASSWORD 变量不应该放在命令行中；在任何项目中都该忽略此变量，然后已存在的数据库不会以任何方式改变。
```

### 重要概念

Image and Container, Volume, Network

移除所有未使用的 volume：`docker volume prune`

### 使用 COPY 还是 VOLUME

VOLUME 是支持热重载的，而 COPY 需要重新 build。

VOLUME 需要跟主机挂钩，而 COPY 直接拷贝到容器中。

