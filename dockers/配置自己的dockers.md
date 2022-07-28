# rendu-env

包含redis，mariadb， ubuntu 容器。运行run.sh部署启动docker环境

# docker-compose -f docker-compose.yml up -d
# docker-compose -p rd_env up -d
# docker run \
#   --detach \
#   --name rd_ubuntu \
#   --hostname UNBUNTU_URL \
#   --publish 5000:5000 \
#   --restart unless-stopped \
#   registry:latest

# docker run \
#   --detach \
#   --name rd_ubuntu \
#   --restart always\
#   --cap-add ALL \
#   --publish 8080:8080 \
 
#   --volume $(pwd)/geoserver/data_dir:/geoserver/data_dir \
#   --volume $(pwd)/geoserver/logs:/geoserver/logs \
#   --hostname geoserver \
#   boiling/ubuntu:20.04