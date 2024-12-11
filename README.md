# Environment Setup

- Since we will potentially modify the model and recipes, copy local repo into docker container and then pip install from the repo. This includes these repo:
  - torchtune
  - transformers
  - huggingface_hub
- Splitted Torchtune into a single docker file to make iteration on this repo faster (only copy and build this repo).
- Assumes GPU is available locally

# Personify.AI - Example Commands & Steps
```
# Build dockerdl-base
docker build -t dockerdl-base:latest --build-arg USERNAME=pls331 --build-arg CUDA_VER=12.4.1 --build-arg UBUNTU_VER=22.04 -f dockerdl/base.Dockerfile .

# Build dockerdl:torch_pls331
docker build -t dockerdl:torch_pls331 -f dockerdl/torch.Dockerfile .

# Build dockerdl-personify:torch_pls331 && Start Container
docker build -t dockerdl-personify:torch_pls331 -f dockerdl/personify.Dockerfile . ; docker run --gpus all -p 2222:22 -v C:\Users\panlu\Documents:/home/pls331/documents -v C:\Users\panlu\Documents\.llama\hf:/tmp -it dockerdl-personify:torch_pls331 bash

# Inside Container
## Test Torchtune 
tune run full_finetune_single_device --config llama3_2/1B_full_single_device epochs=1

# One-liner : Training 1B
docker build -t dockerdl-personify:torch_pls331 -f dockerdl/personify.Dockerfile . ; docker run --gpus all -p 2222:22 -v C:\Users\panlu\Documents:/home/pls331/documents -v C:\Users\panlu\Documents\.llama\hf:/tmp -it dockerdl-personify:torch_pls331 tune run full_finetune_single_device --config personify/personify_1B_full_single_device epochs=1 dump_every_n_step=3

# One-liner : Training 8B
docker build -t dockerdl-personify:torch_pls331 -f dockerdl/personify.Dockerfile . ; docker run --gpus all -p 2222:22 -v C:\Users\panlu\Documents:/home/pls331/documents -v C:\Users\panlu\Documents\.llama\hf:/tmp -it dockerdl-personify:torch_pls331 tune run full_finetune_single_device --config personify/personify_8B_full_single_device epochs=1 dump_every_n_step=3

# One-liner : Generation V2
docker build -t dockerdl-personify:torch_pls331 -f dockerdl/personify.Dockerfile . ; docker run --gpus all -p 2222:22 -v C:\Users\panlu\Documents:/home/pls331/documents -v C:\Users\panlu\Documents\.llama\hf:/tmp -it dockerdl-personify:torch_pls331 tune run dev/generate_v2 --config personify/personify_generation_v2

# Jupiter Notebook
docker run --gpus all -v C:\Users\panlu\Documents:/home/pls331/documents -v C:\Users\panlu\Documents\.llama\hf:/tmp --rm -it -h dockerdl -p 8888:8888 dockerdl-personify:torch_pls331 jupyter lab --no-browser --port 8888 --ServerApp.token='' --ip='*'
```

# TorchTune - Example Commands & Steps
```
## Test Torchtune (Inside Container)
docker build -t dockerdl-torchtune:torch_pls331 -f dockerdl/torchtune.Dockerfile . ; docker run --gpus all -p 2222:22 -v C:\Users\panlu\Documents:/home/pls331/documents -v C:\Users\panlu\Documents\.llama\hf:/tmp -it dockerdl-torchtune:torch_pls331 tune run full_finetune_single_device --config llama3_2/1B_full_single_device epochs=1
```

## Text Encoder
```
# Train
docker build -t dockerdl-torchtune:torch_pls331 -f dockerdl/torchtune.Dockerfile . ; docker run --gpus all -p 2222:22 -v C:\Users\panlu\Documents:/home/pls331/documents -v C:\Users\panlu\Documents\.llama\hf:/tmp -it dockerdl-torchtune:torch_pls331 tune run full_finetune_single_device --config llama3_2_embedding/1B_full_single_device epochs=1

# Eval - MTEB
docker build -t dockerdl-torchtune:torch_pls331 -f dockerdl/torchtune.Dockerfile . ; docker run --gpus all -p 2222:22 -v C:\Users\panlu\Documents:/home/pls331/documents -v C:\Users\panlu\Documents\.llama\hf:/tmp -it dockerdl-torchtune:torch_pls331 tune run dev/eval_mteb --config llama3_2_embedding/eval_mteb_llama3_2_1b
```

docker build -t dockerdl-torchtune:torch_pls331 -f dockerdl/torchtune.Dockerfile . ; docker run --gpus all -p 2222:22 -v C:\Users\panlu\Documents:/home/pls331/documents -v C:\Users\panlu\Documents\.llama\hf:/tmp -it dockerdl-torchtune:torch_pls331 tune run full_finetune_single_device --config llama3_2_embedding/1B_full_single_device epochs=1


docker build -t dockerdl-torchtune:torch_pls331 -f dockerdl/torchtune.Dockerfile . ; docker run --gpus all -p 2222:22 -v C:\Users\panlu\Documents:/home/pls331/documents -v C:\Users\panlu\Documents\.llama\hf:/tmp -it dockerdl-torchtune:torch_pls331 tune run dev/eval_mteb --config llama3_2_embedding/eval_mteb_llama3_2_1b