# dkc

用 docker-compose 快速构建(PHP)环境.

-- dkc 在此作为 docker-compose 的缩写，你可以理解为 `alias dkc=docker-compose`


## <准备>

### 安装 docker

从 repository 安装
```
$ wget https://raw.githubusercontent.com/farwish/delicateShell/master/support/installDockerCE.sh && chmod +x installDockerCE.sh && ./installDockerCE.sh && rm -f installDockerCE.sh
```
https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository  

或者下载 package 安装

https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-from-a-package  


### 安装 docker-compose

```
$ sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

https://docs.docker.com/compose/install/#install-compose


### 网站目录

默认您的网站项目代码放置于 `web/`，当然你可以修改 `docker-compose.yml` 中 volume 的映射关系，然后放置在任何地方。

可以拷贝项目目录到 `web/` 中。


## <指南>

### 如何启动所有服务

修改 `docker-compose.yml` volume 配置项中 `dkc/` 在你主机上的正确路径，然后启动所有：
```
dkc up --build [-d]
```


### 如何运行 Nginx 静态站点

修改nginx服务 volumes 中 web 目录位于主机内的绝对路径; 修改 ports 需要暴露的端口.
```
$ vi docker-compose.yml
```

修改 nginx 的配置 `nginx/nginx.conf`，`nginx/conf.d/default.conf`
```
# 项目路径、暴露端口等配置一般在 nginx/conf.d/default.conf

$ vi nginx/conf.d/default.conf
```

常用命令
```
# 启动 nginx 服务

$ dkc up -d nginx

# 修改完配置都要重启 nginx 服务

$ dkc restart nginx

# 停止 nginx 服务

$ dkc stop nginx

# 查看 nginx 服务日志

$ dkc logs -f --tail 10 nginx

# 查看所有运行的容器

$ dkc ps

# 进入 nginx 容器

$ dkc exec nginx /bin/bash
```

现在可以在浏览器中访问: http://ip

更多内容见 `nginx/README.md`, `nginx/Dockerfile`。


### MySQL 服务

`docker-compose.yml` ports 选项的主机与容器开放的端口映射关系可以修改，以增加安全性。

```
# 启动 MySQL 服务，及其常用操作

$ dkc up -d mysql
$
$ docker logs mysql-con
$
$ dkc exec mysql bash  # 等同: docker exec -it mysql-con bash
$
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

更多内容见 `mysql/Dockerfile`。


### PHP 服务

依赖 MySQL 服务。与 Web Server 配合使用时，关键在于 nginx 配置中要指明 PHP 后端服务的地址为 php-address， `fastcgi_pass   php-address:9000;`

而 php-address 是在 nginx 服务中配置的 --links 项。

现在可以在浏览器中访问: http://ip/phpinfo.php

更多内容见 `php-fpm/README.md`, `php-fpm/Dockerfile`。


### Composer 服务

composer 的作用是安装 PHP 项目中的第三方库，注意修改 volumes 项目目录和 working_dir 。

```
# 查看日志

$ dkc logs -f --tail 20 composer

# 查看运行状态，最终 composer 为 Exit 0 表示运行完毕

$ dkc ps
```

更多内容见 `composer/Dockerfile`。


### Redis 服务

    *解决四个WARNING*

1.no config file specified, using the default config.

默认已通过在 `redis/Dockerfile` 中使用配置文件 `redis/redis.conf` 解除了 WARNING，详细见子目录内 README，你可以修改 `redis/redis.conf` 的配置项满足你的需要。

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

更多内容见 `redis/README.md`, `redis/Dockerfile`。


## <延伸>

### 使用 COPY 还是 VOLUME

VOLUME 是支持热重载的，而 COPY 需要重新 build。

VOLUME 需要跟主机挂钩，而 COPY 直接拷贝到容器中。

移除所有未使用的 volume：`docker volume prune`


### 几个平常可能使用的脚本

* ./compose_remove_all_container.sh # 停止并移除docker-compose启动的容器
* ./remove_none_name_images.sh # 移除名称为 <none> (即没有名称)的镜像
* ./start_all_container.sh # 使用 `docker` 命令逐个启动所有容器
* ./stop_and_remove_all_container.sh # 使用 `docker` 命令逐个停止并删除所有容器


### 系列文章

http://www.cnblogs.com/farwish/tag/Docker/

