#!/bin/bash

docker buildx build \
    --platform linux/amd64,linux/arm64 \
    -t boiling/go_env:latest \
    --push \
    .

# docker build \
#     -t boiling/go_env:latest \
#     .