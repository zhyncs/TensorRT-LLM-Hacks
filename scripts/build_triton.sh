#!/bin/bash

set -ex

rm -rf tensorrtllm_backend
git clone -b main --recurse-submodules --depth=1 https://github.com/triton-inference-server/tensorrtllm_backend
cd tensorrtllm_backend
git lfs install
git submodule update --init --recursive

DOCKER_BUILDKIT=1 docker build -t triton -f dockerfile/Dockerfile.trt_llm_backend .

docker push zhyncs/triton:latest
