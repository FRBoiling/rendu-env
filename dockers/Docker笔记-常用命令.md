# 镜像
## 1、 查看镜像可用版本
docker search 【镜像名称】
```bash
//搜索mysql可用镜像
$ docker search mysql
//搜索debian可用镜像
$ docker search debian
```
## 2、拉取镜像到本地
docker pull 【镜像名称】:【tag版本信息】
```bash
//拖取mysql最新版本镜像
$ docker pull mysql:latest
//拖取mysql5.7版本镜像
$ docker pull mysql:5.7
//拖取debian最新版本镜像
$ docker pull debian:latest
```
## 3、查看本地镜像
 docker images 
【镜像名称【tag版本信息】【镜像ID】
![image.png](https://cdn.nlark.com/yuque/0/2022/png/29336172/1658848074020-24ab7279-bea7-43ec-9245-2986650f3ac5.png#clientId=u109db5e9-0941-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=61&id=ud7ed7a07&margin=%5Bobject%20Object%5D&name=image.png&originHeight=61&originWidth=459&originalType=binary&ratio=1&rotation=0&showTitle=false&size=9616&status=done&style=none&taskId=u02dc3b14-0e73-4a9f-a379-6052f955df1&title=&width=459)
## 4、修改镜像名称和tag版本
docker  tag 【镜像ID】【镜像名称】:【tag版本信息】
```bash
$ docker tag 3218b38490ce mysql8.0.27:8.0.27
```
## 5、删除本地镜像
docker rmi 【镜像名称】:【tag版本信息】
```bash
#删除mysql:latest镜像
$ docker rmi mysql:latest
```
### 删除none的镜像
```bash
$ docker rmi $(docker images | grep "none" | awk '{print $3}')
```
有时候删除失败提示先停止容器，则
```bash
$ docker stop $(docker ps -a | grep "Exited" | awk '{print $1 }') //停止容器
$ docker rm $(docker ps -a | grep "Exited" | awk '{print $1 }') //删除容器
$ docker rmi $(docker images | grep "none" | awk '{print $3}') //删除镜像
```
## 6、镜像导出和导入
```bash
#导出docker save [options] images [images...]
docker save -o 路径/debian1.tar debian:v1
#导入docker load [options]
docker load -i 路径/debian1.tar
```
# 容器
## 1、查看当前容器
其他命令
docker ps                            //显示当前运行容器
docker ps -a                         //显示所有容器
## 2、运行容器
docker run -itd --name 【容器名称】 参数 【镜像ID】
或
docker run -itd --name 【容器名称】 参数 【镜像名称】:【tag版本信息】
```bash
例如：
#mysql 容器
#使用镜像mysql:5.7.0以后台模式启动一个容器,并将容器命名为mysql-test
$ docker run -itd --name mysql-test -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 mysql:5.7.0
$ debian 容器
#使用镜像debian以后台模式启动一个容器,并将容器命名为debian-test
$ docker run -itd --name debian-test debian:v11
```
## 3、进入正在运行容器
docker exec -it 【容器名称】 /bin/bash
或
docker exec -it 【容器Id】 /bin/bash
```bash
docker exec -it debian-test /bin/bash
```
## 4、退出容器
在容器中直接输入
exit                                      //容器停止并退出
ctrl+P+Q                             //容器不停止退出
## 5、启动容器
docker start 【容器名称】  
docker start  【容器ID】   
## 6、重启容器
docker restart 【容器名称】  
docker restart 【容器ID】        
## 7、停止容器
docker stop【容器名称】    
docker stop 【容器ID】         
docker kill 【容器ID】           //强制停止容器
## 8、删除容器
docker rm 【容器名称】  
docker rm -f【容器ID】  
### 删除所有容器
docker rm $(docker ps -aq)      
### 强删
如果不行，强制停止docker ，然后再删除
launchctl list | grep docker     查到进程号然后kill掉
![image.png](https://cdn.nlark.com/yuque/0/2022/png/29336172/1658591243653-a2e65d5d-62b0-4701-b14f-af751b8ba74b.png#clientId=ucb256777-3e7a-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=59&id=lFo4E&margin=%5Bobject%20Object%5D&name=image.png&originHeight=59&originWidth=442&originalType=binary&ratio=1&rotation=0&showTitle=false&size=23856&status=done&style=none&taskId=u97ef8058-0c2d-487e-9c3b-4a7ebdb759f&title=&width=442)
## 9、其他
### 查看容器内部运行的进程
docker top 【容器名称】     
docker top 【容器ID】          
### 查看容器内部的标准输出
docker logs -f【容器名称】    
docker logs -f --tail=30 【容器ID】       
## 10、容器导出和导入
```bash
#导出docker export [options] container
docker export -o 路径/debian.tar debian-test

#导入docker import [options] file|URL|- [REPOSITORY[:TAG]]
docker import 路径/debian.tar debian:v1
```
# 从容器创建一个新的镜像
docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]
OPTIONS说明：
-a :提交的镜像作者；
-c :使用Dockerfile指令来创建镜像；
-m :提交时的说明文字；
-p :在commit时，将容器暂停
 docker commit -m="has update" -a="boil" 1d190ed25119 boil/debian:v12


