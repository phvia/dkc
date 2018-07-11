#
# https://hub.docker.com/_/redis/
#
# 镜像构建的例子：
#   docker build -t redis-img-fw:v1 -f redis/Dockerfile redis/.
#   (如果使用官方默认的image，只需要拉取使用 docker pull redis:3.2.12)
#
# 运行：
#   docker run --name redis-con -d redis-img-fw:v1
#
# 进入容器中：
#   docker exec -it redis-con /bin/bash
#
# 查看环境变量：
#   docker exec redis-con env
#

FROM redis:3.2.12

COPY redis.conf /usr/local/etc/redis/redis.conf

CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
