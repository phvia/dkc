# php-fpm

## How To Custom Image.

Edit **docker-compose-custom.yml** to build custom image.  

After that, you can use the image name in the docker-compose.yml  

And also can push your new image to the hub.  

## Step1.
dkc -f docker-compose-custom.yml build php  
dkc -f docker-compose-custom.yml build web  
dkc -f docker-compose-custom.yml build mysql

## Step2.
vi docker-compose.yml  
dkc up -d --force-recreate  

## Step3.
push your image to the hub.  

---

## 配置文件

1. php.ini


先把 docker-composer-custom.yml volume 中 www.conf 和 php.ini 映射关系注释掉;

等编译好后进入容器拷贝放到目录中再打开 volume 的映射关系。 

源码包文件 php.ini 可直接下载了做映射使用：

```
curl -sS https://raw.githubusercontent.com/php/php-src/php-${PHP_VERSION}/php.ini-production -o php.ini
```

www.conf 因为有些路径和用户名是编译时生成的，不能直接下载了使用 [x] ：

```
curl -sS https://raw.githubusercontent.com/php/php-src/php-${PHP_VERSION}/sapi/fpm/www.conf.in -o php-fpm.d/www.conf
```

项目中 `php.ini` production 一般需要修改的配置项有:

```
expose_php = Off
```
