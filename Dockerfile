# vim: set filetype=dockerfile :
ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}
LABEL org.opencontainers.image.source https://github.com/marvinpinto/kitchensink

# Add the focal-proposed repo
RUN echo "deb http://archive.ubuntu.com/ubuntu/ focal-proposed restricted main multiverse universe" >> /etc/apt/sources.list

# Install git
RUN apt-get -qq update \
  && apt-get install -y software-properties-common \
  && apt-add-repository -y ppa:git-core/ppa \
  && apt-get -qq update \
  && apt-get install -y \
    git \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install the packaged diff-so-fancy
RUN apt-get -qq update \
  && apt-get install -y software-properties-common \
  && apt-add-repository -y ppa:aos1/diff-so-fancy \
  && apt-get -qq update \
  && apt-get install -y \
    diff-so-fancy \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install some utilities I need
RUN apt-get -qq update \
  && apt-get install -y \
    curl \
    vim \
    strace \
    diffstat \
    pkg-config \
    cmake \
    build-essential \
    tcpdump \
    mercurial \
    wget \
    host \
    dnsutils \
    tree \
    dos2unix \
    zip \
    bash-completion \
    aspell \
    aspell-en \
    libjpeg-dev \
    automake \
    editorconfig \
    imagemagick \
    bc \
    lcov \
    man \
    gnupg2 \
    gnupg-agent \
    pinentry-curses \
    psmisc \
    apt-transport-https \
    libxcursor1 \
    libnss3 \
    libgconf-2-4 \
    libasound2 \
    libatk1.0-0 \
    libgtk-3-0 \
    locales \
    sudo \
    xterm \
    ffmpeg \
    libtool \
    libssl-dev \
    pass \
    libpng-dev \
    iputils-ping \
    jq \
    pv \
    socat \
    silversearcher-ag \
    gettext-base \
    parallel \
    ledger \
    net-tools \
    libnss3-tools \
    cpulimit \
    ca-certificates \
    rsync \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Configure timezone and locale
RUN apt-get -qq update \
  && apt-get install -y language-pack-en-base tzdata \
  && echo "America/Toronto" > /etc/timezone \
  && ln -fs /usr/share/zoneinfo/Canada/Eastern /etc/localtime && dpkg-reconfigure -f noninteractive tzdata \
  && echo "LANG=en_US.UTF-8" > /etc/default/locale \
  && echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale \
  && LANGUAGE=en_US.UTF-8 LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 locale-gen --purge en_US.UTF-8 \
  && LANGUAGE=en_US.UTF-8 LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 dpkg-reconfigure -f noninteractive locales \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install go (https://golang.org/dl)
RUN curl https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz | tar -C /usr/local -zx

# Install nvm and a few needed NodeJS versions
ENV NVM_DIR /usr/local/nvm
RUN mkdir -p $NVM_DIR \
    && curl https://raw.githubusercontent.com/creationix/nvm/v0.38.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && echo "yarn" > $NVM_DIR/default-packages \
    && nvm install lts/dubnium \
    && nvm install lts/erbium \
    && nvm install lts/fermium \
    && nvm alias default lts/dubnium \
    && nvm use default

# Utilities needed to run playwright inside the docker container
RUN apt-get -qq update \
  && . $NVM_DIR/nvm.sh \
  && nvm use lts/fermium \
  && npm install -g playwright \
  && DEBIAN_FRONTEND=noninteractive npx playwright install-deps \
  && npm uninstall -g playwright \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install terraform & packer
RUN curl -L https://apt.releases.hashicorp.com/gpg | sudo apt-key add - \
  && apt-get -qq update \
  && echo "deb [arch=amd64] https://apt.releases.hashicorp.com focal main" >> /etc/apt/sources.list.d/hashicorp.list \
  && apt-get -qq update \
  && apt-get install -y terraform packer \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install ngrok to /usr/local/bin
RUN mkdir -p /tmp/ngrok \
  && cd /tmp/ngrok \
  && wget --no-verbose https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip \
  && unzip ngrok-stable-linux-amd64.zip \
  && rm ngrok*.zip \
  && mv ngrok /usr/local/bin \
  && cd /tmp \
  && rm -rf ngrok

# Install python3 + friends
RUN apt-get -qq update \
  && apt-add-repository -y ppa:deadsnakes/ppa \
  && apt-get -qq update \
  && apt-get install -y python3.9 python3.9-dev python3.9-venv python3-setuptools \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
  && update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1 \
  && update-alternatives --set python /usr/bin/python3.9 \
  && python3.9 -m easy_install pip

# Install a bunch of utilities through pip
RUN python3.9 -m pip install awscli ec2instanceconnectcli ansible boto3 netaddr

# Install Java
RUN apt-get -qq update \
  && apt-add-repository -y ppa:openjdk-r/ppa \
  && apt-get -qq update \
  && apt-get install -y \
    openjdk-11-jdk-headless \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install Maven (see https://stackoverflow.com/a/50103533/1101070 for more context)
RUN mkdir -p /tmp/maven \
  && cd /tmp/maven \
  && wget --no-verbose https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz \
  && tar xzf apache-maven-3.6.3-bin.tar.gz \
  && mv apache-maven-3.6.3 /usr/share/maven3 \
  && update-alternatives --install /usr/bin/mvn mvn /usr/share/maven3/bin/mvn 1 \
  && update-alternatives --set mvn /usr/share/maven3/bin/mvn \
  && cd /tmp \
  && rm -rf maven \
  && /usr/bin/printf '\xfe\xed\xfe\xed\x00\x00\x00\x02\x00\x00\x00\x00\xe2\x68\x6e\x45\xfb\x43\xdf\xa4\xd9\x92\xdd\x41\xce\xb6\xb2\x1c\x63\x30\xd7\x92' > /etc/ssl/certs/java/cacerts \
  && /var/lib/dpkg/info/ca-certificates-java.postinst configure

# Install git-lfs
RUN curl -L https://packagecloud.io/github/git-lfs/gpgkey | sudo apt-key add - \
  && apt-get -qq update \
  && echo "deb https://packagecloud.io/github/git-lfs/ubuntu/ focal main" >> /etc/apt/sources.list.d/github_git-lfs.list \
  && apt-get -qq update \
  && apt-get install -y git-lfs \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install 1password cli
RUN mkdir -p /tmp/op \
  && cd /tmp/op \
  && wget --no-verbose https://cache.agilebits.com/dist/1P/op/pkg/v1.8.0/op_linux_amd64_v1.8.0.zip \
  && unzip op_linux_amd64_v1.8.0.zip \
  && rm op*.zip \
  && mv op /usr/local/bin \
  && cd /tmp \
  && rm -rf op

# Install aws-vault
RUN wget --no-verbose -O /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/download/v6.3.1/aws-vault-linux-amd64 \
  && chmod +x /usr/local/bin/aws-vault
RUN wget --no-verbose -O /etc/bash_completion.d/aws-vault https://raw.githubusercontent.com/99designs/aws-vault/v6.3.1/contrib/completions/bash/aws-vault.bash

# Install docker compose within the container
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.0/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose

# Install mkcert within the container
RUN curl -L "https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64" -o /usr/local/bin/mkcert \
  && chmod +x /usr/local/bin/mkcert

# Install kubctl
RUN mkdir -p /tmp/kubectl \
  && cd /tmp/kubectl \
  && wget --no-verbose -O kubectl https://storage.googleapis.com/kubernetes-release/release/v1.19.4/bin/linux/amd64/kubectl \
  && chmod +x ./kubectl \
  && mv kubectl /usr/local/bin/ \
  && cd /tmp \
  && rm -rf kubectl

# Install doctl
RUN mkdir -p /tmp/doctl \
  && cd /tmp/doctl \
  && wget --no-verbose -O doctl.tar.gz https://github.com/digitalocean/doctl/releases/download/v1.58.0/doctl-1.58.0-linux-amd64.tar.gz \
  && tar xf doctl.tar.gz \
  && rm -f doctl.tar.gz \
  && mv doctl* /usr/local/bin/ \
  && cd /tmp \
  && rm -rf doctl

# Install a recentish version of fzf
RUN mkdir -p /tmp/fzf \
  && cd /tmp/fzf \
  && wget --no-verbose https://github.com/junegunn/fzf-bin/releases/download/0.21.1/fzf-0.21.1-linux_amd64.tgz \
  && tar xzf fzf-0.21.1-linux_amd64.tgz \
  && mv fzf /usr/local/bin/fzf \
  && cd /tmp \
  && rm -rf fzf

# Install restic
RUN mkdir -p /tmp/restic \
  && cd /tmp/restic \
  && wget --no-verbose -O restic.bz2 https://github.com/restic/restic/releases/download/v0.12.0/restic_0.12.0_linux_amd64.bz2 \
  && bzip2 -d restic.bz2 \
  && chmod +x ./restic \
  && mv restic /usr/local/bin/ \
  && cd /tmp \
  && rm -rf restic

# Bash completion for fzf
RUN wget --no-verbose -O /etc/bash_completion.d/fzf https://raw.githubusercontent.com/junegunn/fzf/0.21.1/shell/completion.bash
RUN wget --no-verbose -O /etc/bash_completion.d/fzf-key-bindings https://raw.githubusercontent.com/junegunn/fzf/0.21.1/shell/key-bindings.bash

# Install the latest version of slc
RUN curl -L "https://github.com/marvinpinto/slc/releases/download/latest/slc_linux_amd64" -o /usr/local/bin/slc \
  && chmod +x /usr/local/bin/slc

# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
# This is probably a Docker bug.
RUN mkdir /var/shared/ \
  && touch /var/shared/placeholder \
  && chown -R root: /var/shared
VOLUME /var/shared

# Link in shared parts of the home directory
WORKDIR /root
RUN rm -f .bashrc .profile \
  && ln -s /var/shared/.ssh \
  && ln -s /var/shared/.bash_logout \
  && ln -s /var/shared/.bash_profile\
  && ln -s /var/shared/.bashrc \
  && ln -s /var/shared/.bash.d \
  && ln -s /var/shared/.gitconfig \
  && ln -s /var/shared/.gitignore_global \
  && ln -s /var/shared/.profile \
  && ln -s /var/shared/.gnupg \
  && ln -s /var/shared/.ngrok2 \
  && ln -s /var/shared/Dropbox/projects \
  && chown -R root: /root \
  && ln -s /usr/bin/vim /usr/bin/nvim

# Set up the golang development environment
RUN mkdir -p /goprojects/bin
RUN mkdir -p /goprojects/pkg
RUN mkdir -p /goprojects/src
RUN mkdir -p /goprojects/src/github.com/marvinpinto
RUN mkdir -p /goprojects/src/github.com/opensentinel
RUN chown -R root: /goprojects
ENV GOPATH /goprojects

# Set the environment variables
ENV HOME /root
ENV PATH /root/bin:$PATH
ENV PATH /usr/local/go/bin:$PATH
ENV PATH $GOPATH/bin:$PATH
ENV PATH /root/.local/bin:$PATH
ENV PATH $NVM_DIR/version/node/v$NODE_VERSION/bin:$PATH
ENV NODE_PATH $NVM_DIR/version/node/v$NODE_VERSION/lib/node_modules
ENV EDITOR /usr/bin/vim

USER root

ENTRYPOINT "/bin/bash"
