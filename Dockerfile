# vim: set filetype=dockerfile :
FROM ubuntu:14.04

# Add the trusty-proposed repo
RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty-proposed restricted main multiverse universe" >> /etc/apt/sources.list

# Install git
RUN apt-get update \
  && apt-get install -y software-properties-common \
  && apt-add-repository -y ppa:git-core/ppa \
  && apt-get update \
  && apt-get install -y \
    git \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install the latest 2.7.x version of python
RUN apt-get update \
  && apt-add-repository -y ppa:fkrull/deadsnakes-python2.7 \
  && apt-get update \
  && apt-get install -y python2.7 \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install some utilities I need
RUN apt-get update \
  && apt-get install -y \
    python \
    python-pip \
    python-dev \
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
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Configure timezone and locale
RUN echo "America/Toronto" > /etc/timezone \
  && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure tzdata \
  && locale-gen en_US en_US.UTF-8 \
  && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install go
RUN curl https://storage.googleapis.com/golang/go1.5.3.linux-amd64.tar.gz | tar -C /usr/local -zx

# Install nodejs
RUN wget -O /tmp/nodejs.sh https://deb.nodesource.com/setup_5.x \
  && /bin/bash /tmp/nodejs.sh \
  && apt-get install -y nodejs \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install keybase + related
RUN npm install -g keybase-installer \
  && /usr/bin/keybase-installer

# Install ember-cli
RUN npm install -g ember-cli@2.3.0-beta.1

# Install bower
RUN npm install -g bower@1.7.1

# Install phantomjs
RUN mkdir -p /tmp/phantomjs \
  && cd /tmp/phantomjs \
  && wget https://s3.amazonaws.com/travis-phantomjs/phantomjs-2.0.0-ubuntu-14.04.tar.bz2 \
  && tar xfj phantomjs-2.0.0-ubuntu-14.04.tar.bz2 \
  && mv phantomjs /usr/local/bin \
  && cd /tmp \
  && rm -rf phantomjs

# Build and install watchman from source
RUN mkdir -p /tmp/watchman \
  && cd /tmp/watchman \
  && git clone https://github.com/facebook/watchman.git \
  && cd watchman \
  && git checkout v4.3.0 \
  && ./autogen.sh \
  && ./configure \
  && make \
  && sudo make install \
  && cd /tmp \
  && rm -rf watchman

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

# Install packer to /usr/local/bin
RUN mkdir -p /tmp/packer \
  && cd /tmp/packer \
  && wget https://releases.hashicorp.com/packer/0.8.6/packer_0.8.6_linux_amd64.zip \
  && unzip packer_0.8.6_linux_amd64.zip \
  && mv packer /usr/local/bin \
  && mv packer-* /usr/local/bin \
  && cd /tmp \
  && rm -rf packer

# Install terraform to /usr/local/bin
RUN mkdir -p /tmp/terraform \
  && cd /tmp/terraform \
  && wget https://releases.hashicorp.com/terraform/0.6.11/terraform_0.6.11_linux_amd64.zip \
  && unzip terraform_0.6.11_linux_amd64.zip \
  && rm terraform*.zip \
  && mv terraform* /usr/local/bin \
  && cd /tmp \
  && rm -rf terraform

# Install ngrok to /usr/local/bin
RUN mkdir -p /tmp/ngrok \
  && cd /tmp/ngrok \
  && wget https://dl.ngrok.com/ngrok_2.0.19_linux_amd64.zip \
  && unzip ngrok_2.0.19_linux_amd64.zip \
  && rm ngrok*.zip \
  && mv ngrok /usr/local/bin \
  && cd /tmp \
  && rm -rf ngrok

# Install python3 + friends
RUN apt-get update \
  && apt-get install -y python3 python3-dev python3-pip python3.4-venv \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install a bunch of utilities through pip
RUN pip install awscli virtualenv boto dopy cookiecutter docker-compose

# Install the released version of ansible
RUN apt-get update \
  && apt-add-repository -y ppa:ansible/ansible \
  && apt-get -qq update \
  && apt-get install -y ansible \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install Java
RUN mkdir -p /tmp/java \
  && cd /tmp/java \
  && wget \
      --no-check-certificate \
      --no-cookies \
      --header "Cookie: oraclelicense=accept-securebackup-cookie" \
      http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.tar.gz \
  && tar xzf jdk-8u51-linux-x64.tar.gz \
  && mkdir -p /usr/lib/jvm \
  && mv jdk1.8.0_51 /usr/lib/jvm/ \
  && update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.8.0_51/bin/javac 1 \
  && update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.8.0_51/bin/java 1 \
  && update-alternatives --set javac /usr/lib/jvm/jdk1.8.0_51/bin/javac \
  && update-alternatives --set java /usr/lib/jvm/jdk1.8.0_51/bin/java \
  && cd /tmp \
  && rm -rf java

# Install Maven
RUN mkdir -p /tmp/maven \
  && cd /tmp/maven \
  && wget http://apache.mirror.rafal.ca/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz \
  && tar xzf apache-maven-3.3.3-bin.tar.gz \
  && mv apache-maven-3.3.3 /usr/share/maven3 \
  && update-alternatives --install /usr/bin/mvn mvn /usr/share/maven3/bin/mvn 1 \
  && update-alternatives --set mvn /usr/share/maven3/bin/mvn \
  && cd /tmp \
  && rm -rf maven

# Install ruby
RUN apt-get update \
  && apt-get install -y ruby ruby-dev \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install a few gems
RUN gem install travis bundle --no-rdoc --no-ri

# Setup home environment
RUN useradd marvin \
  && echo "marvin ALL = NOPASSWD: ALL" > /etc/sudoers.d/00-marvin \
  &&  mkdir /home/marvin \
  && chown -R marvin: /home/marvin \
  && usermod -aG docker marvin \
  &&  mkdir -p /home/marvin/bin /home/marvin/tmp

# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
# This is probably a Docker bug.
RUN mkdir /var/shared/ \
  && touch /var/shared/placeholder \
  && chown -R marvin: /var/shared
VOLUME /var/shared

# Link in shared parts of the home directory
WORKDIR /home/marvin
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
  && chown -R marvin: /home/marvin

# Set up the golang development environment
RUN mkdir -p /goprojects/bin
RUN mkdir -p /goprojects/pkg
RUN mkdir -p /goprojects/src
RUN mkdir -p /goprojects/src/github.com/marvinpinto
RUN mkdir -p /goprojects/src/github.com/opensentinel
RUN chown -R marvin: /goprojects
ENV GOPATH /goprojects

# Set the environment variables
ENV HOME /home/marvin
ENV PATH /home/marvin/bin:$PATH
ENV PATH /usr/local/go/bin:$PATH
ENV PATH $GOPATH/bin:$PATH

USER marvin

ENTRYPOINT "/bin/bash"
