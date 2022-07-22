#!/bin/bash

# docker-compose up -d
docker-compose -p rd_env -f docker-compose.yml up -d --build

# docker-compose -p rd-env -f ubuntu/docker-ubuntu.yml -f mariadb/docker-mariadb.yml -f redis/docker-redis.yml up -d 
