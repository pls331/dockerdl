FROM dockerdl:torch_pls331

# Install as user 1000
ARG USER_NAME=pls331

# USER ${USER_NAME}

# Shell
SHELL ["/bin/bash", "--login", "-o", "pipefail", "-c"]


RUN pip install --upgrade --no-cache-dir pyarrow sentencepiece bitsandbytes wandb && \
    pip cache purge

# Retrieval Related Libraries
RUN pip install --upgrade --no-cache-dir mteb && \
    pip cache purge

# EluetherAI - Eval Harness
ENV EVAL_HARNESS_DIR=/home/${USER_NAME}/huggingface_hub
# RUN git clone --depth 1 https://github.com/EleutherAI/lm-evaluation-harness
COPY lm-evaluation-harness ${EVAL_HARNESS_DIR}
RUN cd ${EVAL_HARNESS_DIR} && pip install -e .

# Developer Build for TorchTune
# RUN git clone https://github.com/pytorch/torchtune.git /home/${USER_NAME}/torchtune
# Local Repo for Torchtune
ENV TORCHTUNE_DIR=/home/${USER_NAME}/torchtune
COPY torchtune ${TORCHTUNE_DIR}
RUN cd ${TORCHTUNE_DIR} && pip install -e .
