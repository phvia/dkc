# dkc

快速构建(LNMP+Node)运行环境.

dkc 在此作为 docker-compose 的缩写，你可以理解为 `alias dkc=docker-compose`

# 准备

### 安装 docker
----

**选择1)** 从 repository 安装

@guide https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository

```
# 1.支持 Ubuntu 和 CentOS 的安装脚本
$ sudo wget https://raw.githubusercontent.com/farwish/delicateShell/master/support/installDockerCE.sh && chmod +x installDockerCE.sh && ./installDockerCE.sh && rm -f installDockerCE.sh

# 2.将普通用户 xxxx 加入 docker 组
$ sudo usermod -aG docker xxxx

# 3.退出终端重新登录才拥有 docker 执行权限
```

**选择2)** 下载 package 安装

@address https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/  
@guide https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-from-a-package  

```
# 通过 lsb_release -a 查看是不是 xenial，对号选择 package 下载.
$ wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_18.06.0~ce~3-0~ubuntu_amd64.deb

# Ubuntu
$ sudo dpkg -i /path/to/package.deb

# 用 dpkg 安装完deb包，依然执行上面 2,3 两步，让普通用户拥有 docker 执行权限.
```


### 安装 docker-compose
---
```
$ sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

@guide https://docs.docker.com/compose/install/#install-compose


### 下载项目初始化
---
```
$ git clone https://github.com/phvia/dkc
$ cd dkc/ && cp .env.default .env
$ vi .env  # 编辑第一行，即本项目所在路径
```


### 修改网站目录
---
默认您的网站项目代码放置于 `web/`，当然你可以修改 `docker-compose.yml` 中 volume 的映射关系，然后放置在任何地方。

可以拷贝项目目录到 `web/` 中。


# 指南

### 如何启动所有服务
---
修改 `docker-compose.yml` volume 配置项中 `dkc/` 在你主机上的正确路径，然后启动所有：
```
$ dkc up --build -d
```


### 如何运行 Nginx 静态站点
---
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
# 等同 docker run nginx:xxx

$ dkc up -d nginx

# 修改完配置都要重启 nginx 服务
# 等同 docker restart nginx-con

$ dkc restart nginx

# 停止 nginx 服务
# 等同 docker stop nginx-con

$ dkc stop nginx

# 跟踪查看 nginx 服务日志
# 等同 docker logs -f nginx-con

$ dkc logs -f --tail 20 nginx

# 查看所有运行的容器
# 等同 docker ps

$ dkc ps

# 进入 nginx 容器
# 等同 docker exec -it nginx-con bash

$ dkc exec nginx bash
```

现在可以在浏览器中访问: http://host-ip

更多内容见 `nginx/README.md`, `nginx/Dockerfile`。


### MySQL 服务
---
`docker-compose.yml` ports 选项的主机与容器开放的端口映射关系可以修改，以增加安全性。

```
# 启动 MySQL 服务，及其常用操作

$ dkc up -d mysql
$
$ dkc logs -f --tail 20 mysql
$
$ dkc exec mysql bash
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

导入本地数据库文件到容器中
```
# dkc exec [options] [-e KEY=VAL...] SERVICE COMMAND [ARGS...]

$ dkc exec -T mysql mysql -uroot -p123456 testdb < testdb.sql
```

`MYSQL_ROOT_PASSWORD` 环境变量用来初始化 root 用户密码, 只在第一次启动时使用。

一旦初始化数据文件后无法再通过设置本变量更改, 需要删除 volume 之后重新启动，或者进入容器中更改。

`MYSQL_DATABASE` 设置镜像启动时新建的数据库，同样只生效一次，只能进容器内更改 (或者删除 volume)。

更多内容见 `mysql/README.md`。


### PHP 服务
---
依赖 MySQL 服务。与 Web Server 配合使用时，关键在于 nginx 配置中要指明 PHP 后端服务的地址为 php， `fastcgi_pass   php:9000;`

--links 不是必须的，默认服务之间可以通过服务名相互通讯。

--links 的格式是 `SERVICE:ALIAS`，那么使用其它服务的服务名和别名都可以来通讯。

当前已安装常用扩展(比如 phpredis ) 以及 Composer，现在可以在浏览器中访问: http://host-ip/phpinfo.php

更多内容见 `php-fpm/README.md`, `php-fpm/Dockerfile`。


### Redis 服务
---
**需要手动解决前两个WARNING**

1.vm.overcommit_memory is set to 0!

Host 切换至 root，然后按如下设置：
```
$ echo vm.overcommit_memory = 1 >> /etc/sysctl.conf
$ sysctl vm.overcommit_memory=1
```

2.you have Transparent Huge Pages (THP) support enabled in your kernel.

Host 切换至 root，然后按如下设置：
```
# 注意 rc.local 里面如果有 `exit 0`，要放在它之前.
$ echo 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' >> /etc/rc.local
$ source /etc/rc.local
```

3.no config file specified, using the default config.

已通过在 `redis/Dockerfile` 中使用配置文件 `redis/redis.conf` 解除了 WARNING，你可以修改 `redis/redis.conf` 的配置项满足你的需要。

4.The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.

已通过在 `docker-compose.yml` 中配置 sysctls 的选项解除了 WARNING。

更多内容见 `redis/README.md`, `redis/Dockerfile`。


### Web 服务
---

后端PHP运行环境，具体见 `web/README.md`


### Fe 服务
---

前端Node运行环境，具体见 `web/README.md`


# FAQ

### phvia/dkc 能用在哪些宿主机环境
---

在 Ubuntu16.04 上总是能够 build 通过并运行。

其它环境暂时没有测试数据。

### 使用 COPY 还是 VOLUME
---
VOLUME 是支持热重载的，而 COPY 需要重新 build。

VOLUME 需要跟主机挂钩，而 COPY 直接拷贝到容器中。

正式环境建议使用 COPY 拷贝项目到镜像中，避免项目文件更改而影响到运行环境。

移除所有未使用的 volume：`docker volume prune`

### PHP 文件如何连接 MySQL 和 Redis
---
配置的 host 填写服务名，port 填写容器中暴露的端口，非主机端口.


### 几个平常可能使用的脚本
---
* ./compose_remove_all_container.sh # 停止并移除docker-compose启动的容器
* ./remove_none_name_images.sh # 移除名称为 <none> (即没有名称)的镜像
* ./start_all_container.sh # 使用 `docker` 命令逐个启动所有容器
* ./stop_and_remove_all_container.sh # 使用 `docker` 命令逐个停止并删除所有容器


### 系列文章
---
http://www.cnblogs.com/farwish/tag/Docker/
