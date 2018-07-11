#
# Build The Base Ubuntu Image With Basic Tools.
#
# Just change the dockerfile location and the build context location as you like.
#
# In current directory build example:
#   docker build -t ubuntu-base:16.04 -f Dockerfile .
#
# In parent directory build example:
#   docker build -t ubuntu-base:16.04 -f ubuntu/Dockerfile ubuntu/.
#
# VERSION 16.04
#

FROM ubuntu:16.04
MAINTAINER farwish@foxmail.com

RUN apt-get update && apt-get install -y \
    wget \
    curl

