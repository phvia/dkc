#!/bin/bash

imageIds=`docker images | sed '1d' | awk '{print $3}' | xargs`

docker rmi -f $imageIds
