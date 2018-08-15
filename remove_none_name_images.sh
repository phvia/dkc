#!/bin/bash
#
# 移除名称为 <none> (即没有名称)的镜像.
#

noneNameImages=`docker images | grep '<none>' | awk {'print $3'} | xargs`

docker rmi -f $noneNameImages

