# Build arguments
ARG CUDA_VER=12.4.1
ARG UBUNTU_VER=22.04
# Download the base image
FROM nvidia/cuda:${CUDA_VER}-cudnn-runtime-ubuntu${UBUNTU_VER}
# you can check for all available images at https://hub.docker.com/r/nvidia/cuda/tags
# Install as root
USER root
# Shell
SHELL ["/bin/bash", "--login", "-o", "pipefail", "-c"]
# Install dependencies
ARG DEBIAN_FRONTEND="noninteractive"
ARG PASSWORD=PLS19910729
ARG USERNAME=pls331
ARG USERID=1000
ARG GROUPID=1000
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    bash-completion \
    ca-certificates \
    curl \
    git \
    htop \
    nano \
    nvidia-modprobe \
    nvtop \
    openssh-client \
    openssh-server \
    python3 python3-dev python3-pip python-is-python3 \
    sudo \
    tmux \
    zsh \
    unzip \
    vim \
    wget \ 
    zip \
    tree \
    zsh \
    rake \
    build-essential && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Zsh
RUN sudo apt update && sudo apt install -y --no-install-recommends 
# RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # oh my zsh
RUN sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"

# Download and install zellij
RUN curl -L -o zellij.tar.gz https://github.com/zellij-org/zellij/releases/download/v0.40.1/zellij-x86_64-unknown-linux-musl.tar.gz && \
    tar -xzf zellij.tar.gz -C /usr/local/bin && \
    rm zellij.tar.gz && \
    zellij --version

# Add a user `${USERNAME}` so that you're not developing as the `root` user
RUN groupadd -g ${GROUPID} ${USERNAME} && \
    useradd ${USERNAME} \
    --create-home \
    --uid ${USERID} \
    --gid ${GROUPID} \
    --shell=/bin/bash && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd



# Create a directory for the SSH daemon
RUN mkdir /var/run/sshd
# Optionally, create a user for SSH (set a password)
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd
# Optionally, allow root login (only if needed, not recommended)
# RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
# Configure SSH daemon to accept remote connections
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
# Generate SSH host keys
RUN chmod 700 /etc/ssh
RUN chmod 600 /etc/ssh/ssh_host_*
RUN chmod a+rw /etc/ssh/sshd_config
RUN ssh-keygen -A
# Expose port 22 (the default SSH port)
EXPOSE 22

# # Change to your user
# Chnage Workdir

WORKDIR /home/${USERNAME}
# VScode Tunnel Extention
RUN curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' --output vscode_cli.tar.gz && tar -xf vscode_cli.tar.gz

USER ${USERNAME}
# Install packages inside the new environment
RUN pip install --upgrade --no-cache-dir pip setuptools wheel && \
    pip install --upgrade --no-cache-dir \
    ipywidgets \
    jupyterlab \
    matplotlib \
    nltk \
    notebook \
    numpy \
    pandas \
    Pillow \
    plotly \
    PyYAML \
    scipy \
    scikit-image \
    scikit-learn \
    sympy \
    seaborn \
    tqdm && \
    pip cache purge && \
    # Set path of python packages
    echo "# Set path of python packages" >>/home/${USERNAME}/.bashrc && \
    echo 'export PATH=$HOME/.local/bin:$PATH' >>/home/${USERNAME}/.bashrc

# Start the SSH service
CMD ["/usr/sbin/sshd", "-D"]
