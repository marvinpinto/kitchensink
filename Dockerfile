# vim: set filetype=dockerfile :
FROM ubuntu:14.04

# Install a bunch of utilities
RUN apt-get update -y
RUN apt-get install -y git \
  python \
  curl \
  vim \
  strace \
  diffstat \
  pkg-config \
  cmake \
  build-essential \
  tcpdump \
  tmux \
  mercurial \
  wget \
  host \
  dnsutils \
  zip

RUN locale-gen en_US en_US.UTF-8 && \
  dpkg-reconfigure locales 

# Install go
RUN curl https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz | tar -C /usr/local -zx
ENV GOROOT /usr/local/go
ENV PATH /usr/local/go/bin:$PATH

# Install fleetctl to /usr/local/bin
RUN \
  wget https://github.com/coreos/fleet/releases/download/v0.10.0/fleet-v0.10.0-linux-amd64.tar.gz && \
  tar -zxvf fleet-v0.10.0-linux-amd64.tar.gz && \
  mv fleet-v0.10.0-linux-amd64/fleetctl /usr/local/bin && \
  rm -rf fleet-v0.10.0-linux-amd64.tar.gz fleet-v0.10.0-linux-amd64

# Install etcd-ca to /usr/local/bin
RUN cd /tmp \
  && git clone https://github.com/coreos/etcd-ca \
  && cd etcd-ca \
  && ./build \
  && mv ./bin/etcd-ca /usr/local/bin \
  && cd /tmp \
  && rm -rf etcd-ca

# Setup home environment
RUN useradd dev
RUN echo "dev ALL = NOPASSWD: ALL" > /etc/sudoers.d/00-dev
RUN mkdir /home/dev && chown -R dev: /home/dev
RUN mkdir -p /home/dev/go/src /home/dev/bin /home/dev/lib /home/dev/include /home/dev/tmp
ENV PATH /home/dev/bin:$PATH
ENV PKG_CONFIG_PATH /home/dev/lib/pkgconfig
ENV LD_LIBRARY_PATH /home/dev/lib
ENV GOPATH /home/dev/go
ENV PATH $GOPATH/bin:$PATH

# Build & Install terraform
RUN git clone https://github.com/hashicorp/terraform.git $GOPATH/src/github.com/hashicorp/terraform && \
  cd $GOPATH/src/github.com/hashicorp/terraform && \
  XC_OS=linux XC_ARCH=amd64 make updatedeps bin

# Install jekyll + dependencies
RUN apt-get install -y software-properties-common \
  && apt-add-repository -y ppa:brightbox/ruby-ng \
  && apt-get update \
  && apt-get install -y \
  ruby2.2 \
  ruby2.2-dev \
  npm \
  && gem install --no-document bundler \
  && apt-get clean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
# This is probably a Docker bug.
RUN mkdir /var/shared/
RUN touch /var/shared/placeholder
RUN chown -R dev:dev /var/shared
VOLUME /var/shared

# Link in shared parts of the home directory
WORKDIR /home/dev
ENV HOME /home/dev
run ln -s /var/shared/.ssh
run ln -s /var/shared/.bash_logout
run ln -s /var/shared/.bash_profile
run ln -s /var/shared/.bashrc
run ln -s /var/shared/.gitconfig
run ln -s /var/shared/.gitignore_global
run ln -s /var/shared/.profile
run ln -s /var/shared/.tmux.conf
run ln -s /var/shared/.vim
run ln -s /var/shared/.vimrc
run ln -s /var/shared/Dropbox/freshbooks
run ln -s /var/shared/Dropbox/projects

RUN chown -R dev: /home/dev
USER dev

ENTRYPOINT "/bin/bash"
