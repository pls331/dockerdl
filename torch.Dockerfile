# FROM matifali/dockerdl-base:latest
FROM dockerdl-base:latest

# Install as user 1000
ARG USER_NAME=pls331

# USER ${USER_NAME}

# Shell
SHELL ["/bin/bash", "--login", "-o", "pipefail", "-c"]
# Install pytorch
RUN pip install --upgrade --no-cache-dir torch torchvision torchaudio torchtext torchserve torchao && \
    pip install --upgrade --no-cache-dir lightning && \
    pip cache purge

# RUN pip instal --upgrade --no-cache-dir  transformers huggingface_hub \
#     pip instal --upgrade --no-cache-dir 'huggingface_hub[cli,torch]' \
#     pip cache purge

# huggingface_hub
RUN git clone https://github.com/huggingface/huggingface_hub.git /home/${USER_NAME}/huggingface_hub
RUN cd /home/${USER_NAME}/huggingface_hub && pip install -e .

# HF - transformers
RUN git clone https://github.com/huggingface/transformers.git /home/${USER_NAME}/transformers
RUN cd /home/${USER_NAME}/transformers && pip install -e .
RUN mkdir -p /home/${USER_NAME}/models
ENV TRANSFORMERS_CACHE=/home/${USER_NAME}/models
# ENV HF_HUB_OFFLINE=1


# Developer Build for TorchTune
# RUN git clone https://github.com/pytorch/torchtune.git /home/${USER_NAME}/torchtune
# RUN cd /home/${USER_NAME}/torchtune && pip install -e .
