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

# RUN pip instal --upgrade --no-cache-dir  transformers huggingface_hub && \
#     pip instal --upgrade --no-cache-dir 'huggingface_hub[cli,torch]' && \
#     pip cache purge

RUN pip install --upgrade --no-cache-dir accelerate tiktoken blobfile && \
    pip cache purge

# huggingface_hub
ENV HF_HUB_DIR=/home/${USER_NAME}/huggingface_hub
# RUN git clone https://github.com/huggingface/huggingface_hub.git ${HF_HUB_DIR}
COPY huggingface_hub ${HF_HUB_DIR}
RUN cd ${HF_HUB_DIR} && pip install -e .

# HF - transformers
ENV TRANSFORMERS_DIR=/home/${USER_NAME}/transformers
# RUN git clone https://github.com/huggingface/transformers.git ${TRANSFORMERS_DIR}
COPY transformers ${TRANSFORMERS_DIR}
RUN cd  ${TRANSFORMERS_DIR} && pip install -e .
RUN mkdir -p /home/${USER_NAME}/hf_models
ENV TRANSFORMERS_CACHE=/home/${USER_NAME}/hf_models
ENV HF_HOME=/home/${USER_NAME}/hf_models
# ENV HF_HUB_OFFLINE=1

