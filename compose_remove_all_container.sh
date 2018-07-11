#!/bin/bash
#
# 停止并移除docker-compose启动的容器
#

docker-compose stop
docker-compose rm -f
