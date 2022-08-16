# 前言
本系列介绍如何基于docker-compose部署一套自己的开发环境。
教程从下面常用环境讲解，希望举一反三。
1、networks 配置
2、services 配置

- 开发机（ubuntu）
- redis
- mariadb

废话不多说，直接上真相~！先！
# 总览
给大家上一套我自己的简单的学习环境配置~先！
[https://github.com/FRBoiling/rendu-env](https://github.com/FRBoiling/rendu-env)
![image.png](https://cdn.nlark.com/yuque/0/2022/png/29336172/1658464595787-48a09c91-11ca-4961-ad64-0b1d5d94ae48.png#clientId=ud99bc018-1589-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=166&id=ufe97ab43&margin=%5Bobject%20Object%5D&name=image.png&originHeight=166&originWidth=241&originalType=binary&ratio=1&rotation=0&showTitle=false&size=6858&status=done&style=none&taskId=u2813273b-6787-4a0e-aa96-b1cb12bcda4&title=&width=241)
docker-compose.yml内容如下：
```yaml
version: "3.9"
# 网络
networks:
  inner: # 名为inner的网络
    driver: bridge  # 桥接模式
    ipam:
      config:
        - subnet: 172.20.0.0/16
          gateway: 172.20.0.1 #网关地址

# 定义服务
services:

  ubuntu:    
    container_name: rd_ubuntu # 指定一个自定义容器名称，而不是生成的默认名称。
    image: ubuntu:latest			# 服务的镜像名称或镜像ID。如果镜像在本地不存在，Compose将会尝试拉取镜像
    restart: always						# 容器总是重新启动
    cap_add:
      - ALL				# 使用ALL参数，container内的root拥有全部权限。同privileged: true类似
    build:				# 构建参数
      context: ./ubuntu  					# docker配置目录
      dockerfile: Dockerfile			# dockerfile文件名
      args:
        buildno: 1
    ports:			# 配置端口 - "宿主机端口:容器暴露端口"
      - "22:22" # 22是ssh端口      
      - "873:873" # 873是srync端口
    networks:	# 配置所属网络，引用networks下的条目(就是最上面配置的networks中配置的网络)
      inner:	# 加入到名为inner的网络
        aliases:	
          - UBUNTU_URL	# 为本容器创建别名
 
  redis:
    container_name: rd_redis  
    image: redis:latest
    restart: always
    cap_add:
      - ALL 
    build:
      context: ./redis
      dockerfile: Dockerfile
    ports:
      - 6379:6379
    volumes:   # 挂载 配置
      - "./redis/conf/redis.conf:/etc/redis/redis.conf"
      - "./redis/data:/data"
    networks:
      inner:
        aliases:  #不配置aliases也可以, 这样就通过定义的服务名: redis 来连接
          - REDIS_URL   #创建别名REDIS_URL，标记为redis服务的地址.        

  mariadb:
    container_name: rd_mariadb
    image: boiling/mariadb:latest
    restart: always
    # privileged: true
    cap_add:
      - ALL
    build:
      context: ./mariadb
      dockerfile: Dockerfile
    ports:
      - 3306:3306
    volumes:
      - "/etc/localtime:/etc/localtime"
      - "./mariadb/conf:/etc/mysql/conf.d"
      - "./mariadb/logs:/var/log/mysql"
      - "./mariadb/data:/var/lib/mysql"
      # - "/rendu-env/dockers/mysql/sql/init.sql:/docker-entrypoint-initdb.d/init.sql"
    environment:    # 添加环境变量   
      MARIADB_ROOT_PASSWORD: root   # root 密码
      MYSQL_ROOT_HOST: '%'	     		# root 允许登录的host
      TIME_ZONE: Asia/Shanghai		  # 时区
    networks:
      inner:
        aliases:
          - MYSQL_URL
```
run.sh内容如下
```bash
#!/bin/bash
# 从docker-compose.yml 构建一个名为rd_env的环境
docker-compose -p rd_env -f docker-compose.yml up -d --build
```
# 运行
进入dockers目录，执行run.sh脚本，即可开始构建和启动环境中整套服务



