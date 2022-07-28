#!/bin/bash

docker buildx build \
    --platform linux/amd64,linux/arm64 \
    -t boiling/ubuntu:20.04 \
    --push \
    .

