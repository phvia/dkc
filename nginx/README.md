# nginx

## 配置文件

1.nginx.conf

修改的配置项:
```
http {
    gzip  on;
    server_tokens off;
}
```

2.conf.d/default.conf

修改的配置项:
```
server {
}
```

你可以获取到当前使用版本的配置文件，例如:
```
wget https://raw.githubusercontent.com/nginx/nginx/release-1.14.0/conf/nginx.conf
```
注意，容器中默认的 `nginx.conf` 中没有 `server` 段，所以原始配置使用时也需要移除一下。

Nginx 配置文件 https://nginx.org/en/docs/http/ngx_http_core_module.html

## 进入容器

`docker exec -it nginx-con /bin/bash`  or `docker-compose nginx bash`

