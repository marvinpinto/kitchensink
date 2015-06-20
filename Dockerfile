# vim: set filetype=dockerfile :
FROM ubuntu:14.04

# Install git 2.4.2
RUN apt-get update \
  && apt-get install -y software-properties-common \
  && apt-add-repository -y ppa:git-core/ppa \
  && apt-get update \
  && apt-get install -y \
    git=1:2.4.2-0ppa1~ubuntu14.04* \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install some utilities I need
RUN apt-get update \
  && apt-get install -y \
    python \
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
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Configure timezone and locale
RUN echo "America/Toronto" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata
RUN export LANGUAGE=en_US.UTF-8; export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8; locale-gen en_US.UTF-8; DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install go
RUN curl https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz | tar -C /usr/local -zx

# Install fleetctl to /usr/local/bin
RUN mkdir -p /tmp/fleetctl \
  && cd /tmp/fleetctl \
  && wget https://github.com/coreos/fleet/releases/download/v0.10.1/fleet-v0.10.1-linux-amd64.tar.gz \
  && tar -zxvf fleet-v0.10.1-linux-amd64.tar.gz \
  && mv fleet-v0.10.1-linux-amd64/fleetctl /usr/local/bin \
  && cd /tmp \
  && rm -rf fleetctl

# Install terraform to /usr/local/bin
RUN mkdir -p /tmp/terraform \
  && cd /tmp/terraform \
  && wget https://dl.bintray.com/mitchellh/terraform/terraform_0.5.1_linux_amd64.zip \
  && unzip terraform_0.5.1_linux_amd64.zip \
  && mv terraform /usr/local/bin \
  && mv terraform-* /usr/local/bin \
  && cd /tmp \
  && rm -rf terraform

# Install keybase + related
RUN apt-get update \
  && apt-get install -y \
    nodejs-legacy \
    npm \
  && npm install -g keybase-installer \
  && /usr/local/bin/keybase-installer \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install ledger
RUN apt-get install -y software-properties-common \
  && apt-add-repository -y ppa:mbudde/ledger \
  && apt-get update \
  && apt-get install -y ledger \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install docker
RUN wget -O /tmp/docker.sh https://get.docker.com/ \
  && /bin/sh /tmp/docker.sh \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install the wercker cli
RUN wget -O /tmp/wercker.sh https://install.wercker.com \
  && /bin/sh /tmp/wercker.sh \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install packer to /usr/local/bin
RUN mkdir -p /tmp/packer \
  && cd /tmp/packer \
  && wget https://dl.bintray.com/mitchellh/packer/packer_0.7.5_linux_amd64.zip \
  && unzip packer_0.7.5_linux_amd64.zip \
  && mv packer /usr/local/bin \
  && mv packer-* /usr/local/bin \
  && cd /tmp \
  && rm -rf packer

# Install python + friends
RUN apt-get update \
  && apt-get install -y python python-dev python-pip libmysqlclient-dev \
  && pip install virtualenv \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Setup home environment
RUN useradd dev \
  && echo "dev ALL = NOPASSWD: ALL" > /etc/sudoers.d/00-dev \
  &&  mkdir /home/dev \
  && chown -R dev: /home/dev \
  && usermod -aG docker dev \
  &&  mkdir -p /home/dev/bin /home/dev/tmp

# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
# This is probably a Docker bug.
RUN mkdir /var/shared/ \
  && touch /var/shared/placeholder \
  && chown -R dev:dev /var/shared
VOLUME /var/shared

# Link in shared parts of the home directory
WORKDIR /home/dev
RUN ln -s /var/shared/.ssh \
  && ln -s /var/shared/.bash_logout \
  && ln -s /var/shared/.bash_profile\
  && ln -s /var/shared/.bashrc \
  && ln -s /var/shared/.gitconfig \
  && ln -s /var/shared/.gitignore_global \
  && ln -s /var/shared/.profile \
  && ln -s /var/shared/.vim \
  && ln -s /var/shared/.vimrc \
  && ln -s /var/shared/Dropbox/freshbooks \
  && ln -s /var/shared/Dropbox/projects \
  && ln -s /var/shared/Dropbox/gnupg .gnupg \
  && chown -R dev: /home/dev

# Set the environment variables
ENV HOME /home/dev
ENV PATH /home/dev/bin:$PATH
ENV PATH /usr/local/go/bin:$PATH

USER dev

ENTRYPOINT "/bin/bash"
