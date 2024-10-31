# Environment Setup

- Since we will potentially modify the model and recipes, copy local repo into docker container and then pip install from the repo. This includes these repo:
  - torchtune
  - transformers
  - huggingface_hub
- Splitted Torchtune into a single docker file to make iteration on this repo faster (only copy and build this repo).
- Assumes GPU is available locally

# Example Commands & Steps
```
# Build dockerdl-base
docker build -t dockerdl-base:latest --build-arg USERNAME=pls331 --build-arg CUDA_VER=12.4.1 --build-arg UBUNTU_VER=22.04 -f base.Dockerfile .

# Build dockerdl:torch_pls331
docker build -t dockerdl:torch_pls331 -f dockerdl/torch.Dockerfile .

# Build dockerdl-personify:torch_pls331 && Start Container
docker build -t dockerdl-personify:torch_pls331 -f dockerdl/personify.Dockerfile . ; docker run --gpus all -p 2222:22 -v C:\Users\panlu\Documents:/home/pls331/documents -v C:\Users\panlu\Documents\.llama\hf:/tmp -it dockerdl-personify:torch_pls331 bash

# Inside Container
## Test Torchtune 
tune run full_finetune_single_device --config llama3_2/1B_full_single_device epochs=1


# One-liner
docker build -t dockerdl-personify:torch_pls331 -f dockerdl/personify.Dockerfile . ; docker run --gpus all -p 2222:22 -v C:\Users\panlu\Documents:/home/pls331/documents -v C:\Users\panlu\Documents\.llama\hf:/tmp -it dockerdl-personify:torch_pls331 tune run full_finetune_single_device --config llama3_2/1B_full_single_device epochs=1
```
