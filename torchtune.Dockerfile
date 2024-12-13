FROM dockerdl:torch_pls331
# FROM dockerdl-base:latest

# Install as user 1000
ARG USER_NAME=pls331
USER root
# USER ${USER_NAME}

# Shell
SHELL ["/bin/bash", "--login", "-o", "pipefail", "-c"]


ENV SENTENCE_TRANSFORMERS_HOME=/tmp/hf_cache/sentence_transformers
RUN pip install --upgrade --no-cache-dir sentence_transformers mteb 

# Retrieval Related Libraries
# TODO (pls331) : better to set this env variable through docker run command instead of here

# EluetherAI - Eval Harness
ENV EVAL_HARNESS_DIR=/home/${USER_NAME}/lm-evaluation-harness
# RUN git clone --depth 1 https://github.com/EleutherAI/lm-evaluation-harness
COPY lm-evaluation-harness ${EVAL_HARNESS_DIR}
RUN cd ${EVAL_HARNESS_DIR} && pip install -e .

# Developer Build for TorchTune
ENV TORCHTUNE_DIR=/home/${USER_NAME}/torchtune
# RUN git clone https://github.com/pytorch/torchtune.git ${TORCHTUNE_DIR}
# Local Repo for Torchtune
COPY torchtune ${TORCHTUNE_DIR}
# TODO (pls331) : maybe better to setup editable mode and avoid copying the repo
RUN python3 -m pip install --upgrade pip
# RUN cd ${TORCHTUNE_DIR} && sudo pip install -e .["dev"] 
RUN cd ${TORCHTUNE_DIR} && sudo pip install -e .
# RUN cd ${TORCHTUNE_DIR} && sudo pip install .
ENV CC=gcc
# sudo pip install .

