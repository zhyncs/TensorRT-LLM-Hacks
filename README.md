# TensorRT-LLM-Hacks
TensorRT LLM Hacks

## Usage

```bash
docker pull zhyncs/trtllm:latest
docker run -itd --shm-size 32g --gpus all zhyncs/trtllm:latest /bin/bash

docker pull zhyncs/triton:latest
docker run -itd --shm-size 32g --gpus all zhyncs/triton:latest /bin/bash
```
