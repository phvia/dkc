FROM composer:1.6

# 如果要支持多个项目？

WORKDIR /usr/share/nginx/html/so-fw

CMD ["composer", "install"]

CMD ["mkdir", "-p", "-m", "0777", "var/"]

CMD ["composer", "dump-autoload", "-o"]


