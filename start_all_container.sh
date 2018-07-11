#!/bin/bash
#
# 使用 `docker` 命令逐个启动所有容器。
#
# https://hub.docker.com/_/nginx/
# https://hub.docker.com/_/mysql/
# https://hub.docker.com/_/redis/
# https://hub.docker.com/_/php/
#

mysqlImage='mysql-img-farwish:v1'
redisImage='redis-img-farwish:v1'
nginxImage='nginx:1.15.0'
phpImage='php:7.1.19-fpm'

docker build -t mysql-img-farwish:v1 -f ./mysql/Dockerfile ./mysql/.
docker build -t redis-img-farwish:v1 -f ./redis/Dockerfile ./redis/.

#echo 511 > /proc/sys/net/core/somaxconn

# Add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot.
# or run the command 'sysctl vm.overcommit_memory=1'
#echo vm.overcommit_memory=1 >> /etc/sysctl.conf

# Write into rc.local for valid when reboot.
echo never > /sys/kernel/mm/transparent_hugepage/enabled

docker run --name nginx-con -d $nginxImage
docker run --name mysql-con -e MYSQL_ROOT_PASSWORD=123456 -d $mysqlImage
docker run --name redis-con -d $redisImage
docker run --name php-con -d $phpImage

echo -e "Done\n"

docker ps
