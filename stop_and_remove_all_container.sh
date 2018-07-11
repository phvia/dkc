#!/bin/bash
#
# 使用 `docker` 命令逐个停止并删除所有容器。
#

set -e

# Stop all
runningContainerIDs=`docker ps | sed '1d' | awk {'print $1'} | xargs`
if [ -n "$runningContainerIDs" ]; then
    docker stop $runningContainerIDs
fi

# Remove all
allContainerIDs=`docker ps -a | sed '1d' | awk {'print $1'} | xargs`
if [ -n "$allContainerIDs" ]; then
    docker rm $allContainerIDs
fi

echo -e "Done\n"

docker ps -a
