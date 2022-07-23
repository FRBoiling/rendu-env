#!/bin/bash

# docker-compose up -d
# docker-compose -p rd_env -f docker-compose.yml up -d --build

docker-compose -p rd_env -f ubuntu/docker-compose.yml -f cpp_env/docker-compose.yml -f redis/docker-compose.yml up -d 
