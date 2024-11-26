#!/bin/bash

set -ex

rm -rf TensorRT-LLM
git clone -b main --recurse-submodules --depth=1 https://github.com/NVIDIA/TensorRT-LLM
cd TensorRT-LLM

BRANCH=$(git rev-parse --abbrev-ref HEAD | cut -d '/' -f2)
TRT_VER=$(grep "^TRT_VER=" docker/common/install_tensorrt.sh | cut -d'"' -f2)
CUDA_VER=$(grep "^CUDA_VER=" docker/common/install_tensorrt.sh | cut -d'"' -f2 | cut -d' ' -f1)
CUDNN_VER=$(grep "^CUDNN_VER=" docker/common/install_tensorrt.sh | cut -d'"' -f2)
NCCL_VER=$(grep "^NCCL_VER=" docker/common/install_tensorrt.sh | cut -d'"' -f2)
CUBLAS_VER=$(grep "^CUBLAS_VER=" docker/common/install_tensorrt.sh | cut -d'"' -f2)
NVRTC_VER=$(grep "^NVRTC_VER=" docker/common/install_tensorrt.sh | cut -d'"' -f2)
CUDA_RUNTIME=$(grep "^CUDA_RUNTIME=" docker/common/install_tensorrt.sh | cut -d'"' -f2)

make -C docker wheel_build \
    BUILD_WHEEL_ARGS="--clean --benchmarks --trt_root /usr/local/tensorrt" \
    IMAGE_WITH_TAG="zhyncs/trtllm:latest" \
    CUDA_ARCHS="80-real;86-real;89-real;90-real" \
    TRT_VERSION=${TRT_VER} \
    CUDA_VERSION=${CUDA_VER} \
    CUDNN_VERSION=${CUDNN_VER} \
    NCCL_VERSION=${NCCL_VER} \
    CUBLAS_VERSION=${CUBLAS_VER} \
    NVRTC_VER=${NVRTC_VER} \
    CUDA_RUNTIME=${CUDA_RUNTIME}

docker push zhyncs/trtllm:latest
