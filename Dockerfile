# vim: set filetype=dockerfile :
ARG DEBIAN_FRONTEND=noninteractive
ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}
LABEL org.opencontainers.image.source https://github.com/marvinpinto/kitchensink

# Base utilities
RUN apt-get -qq update \
  && apt-get install -y \
    build-essential \
    procps \
    curl \
    file \
    git \
    apt-transport-https \
    ca-certificates \
    bash-completion \
    iputils-ping \
    wget \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Linuxbrew setup
RUN groupadd -f linuxbrew \
  && mkdir -p /home/linuxbrew \
  && chown root:linuxbrew /home/linuxbrew \
  && chmod 0775 /home/linuxbrew

# Linuxbrew install
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
  && brew analytics off \
  && brew install gcc git ansible chezmoi \
  && brew tap marvinpinto/kitchensink "https://github.com/marvinpinto/kitchensink.git" \
  && brew install \
    marvinpinto/kitchensink/op \
    aws-vault \
    cheat \
    fzf \
    git \
    ansible \
    git-lfs \
    mkcert \
    neovim \
    rclone \
    jq \
    go@1.17 \
    nvm \
    terraform \
    packer \
    python \
    openjdk@11 \
    maven \
    docker-compose \
    kubectl \
    doctl \
    fzf \
    restic \
    aws-vault \
    awscli \
    git-delta \
    yarn-completion \
    gcc@5 \
    the_silver_searcher

# Configure timezone and locale
ENV TZ="America/Toronto"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone \
  && apt-get -qq update \
  && apt-get install -y --no-install-recommends language-pack-en-base tzdata \
  && dpkg-reconfigure -f noninteractive tzdata \
  && echo "LANG=en_US.UTF-8" > /etc/default/locale \
  && echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale \
  && LANGUAGE=en_US.UTF-8 LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 locale-gen --purge en_US.UTF-8 \
  && LANGUAGE=en_US.UTF-8 LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 dpkg-reconfigure -f noninteractive locales \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Setup nvm + install a few needed NodeJS versions
ENV NVM_DIR /usr/local/nvm
RUN mkdir -p $NVM_DIR \
  && . /home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh \
  && echo "yarn" > $NVM_DIR/default-packages \
  && nvm install lts/dubnium \
  && nvm install lts/erbium \
  && nvm install lts/fermium \
  && nvm alias default lts/dubnium \
  && nvm use default

# Utilities needed to run playwright inside the docker container
RUN apt-get -qq update \
  && . /home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh \
  && nvm use lts/fermium \
  && npm install -g playwright \
  && npx playwright install-deps \
  && npm uninstall -g playwright \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install the latest version of slc
RUN curl -L "https://github.com/marvinpinto/slc/releases/download/latest/slc_linux_amd64" -o /usr/local/bin/slc \
  && chmod +x /usr/local/bin/slc

# Environment setup
RUN mkdir -p /home/worker/app \
  && touch /home/worker/app/.placeholder \
  && chown -R root: /home/worker
VOLUME /home/worker/app
WORKDIR /home/worker/app

ENV HOME /home/worker
ENV PATH /home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/home/worker/bin:/usr/local/go/bin:/home/worker/.local/bin:$NVM_DIR/version/node/v$NODE_VERSION/bin:$PATH
ENV NODE_PATH $NVM_DIR/version/node/v$NODE_VERSION/lib/node_modules
ENV EDITOR nvim

USER root

ENTRYPOINT "/bin/bash"
