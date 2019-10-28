# vim: set filetype=dockerfile :
FROM ubuntu:16.04

# Add the xenial-proposed repo
RUN echo "deb http://archive.ubuntu.com/ubuntu/ xenial-proposed restricted main multiverse universe" >> /etc/apt/sources.list

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

# Install some utilities I need
RUN apt-get -qq update \
  && apt-get install -y \
    python \
    python-pip \
    python-dev \
    curl \
    vim \
    vim-gtk \
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
    libpng16-dev \
    iputils-ping \
    jq \
    pv \
    socat \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Utilities needed to run headless Chrome inside the docker container (see
# https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md)
RUN apt-get -qq update \
  && apt-get install -y \
    gconf-service \
    libasound2 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    ca-certificates \
    fonts-liberation \
    libappindicator1 \
    libnss3 \
    lsb-release \
    xdg-utils \
    wget \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Configure timezone and locale
RUN apt-get -qq update \
  && apt-get install -y language-pack-en-base \
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
RUN curl https://dl.google.com/go/go1.11.1.linux-amd64.tar.gz | tar -C /usr/local -zx

# Install nvm and a few needed NodeJS versions
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8.11.1
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install 6.10.3 \
    && nvm install 6.11.2 \
    && nvm install 8.10 \
    && nvm install 10.16.3 \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# Install the npm bash completion script
RUN wget --no-verbose -O /etc/bash_completion.d/npm https://raw.githubusercontent.com/npm/npm/v4.1.0/lib/utils/completion.sh

# Install phantomjs
RUN mkdir -p /tmp/phantomjs \
  && cd /tmp/phantomjs \
  && wget --quiet https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
  && tar xfj phantomjs-2.1.1-linux-x86_64.tar.bz2 \
  && mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin \
  && cd /tmp \
  && rm -rf phantomjs

# Install ledger
RUN apt-get install -y software-properties-common \
  && apt-add-repository -y ppa:mbudde/ledger \
  && apt-get -qq update \
  && apt-get install -y ledger \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install packer to /usr/local/bin
RUN mkdir -p /tmp/packer \
  && cd /tmp/packer \
  && wget --no-verbose https://releases.hashicorp.com/packer/0.8.6/packer_0.8.6_linux_amd64.zip \
  && unzip packer_0.8.6_linux_amd64.zip \
  && mv packer /usr/local/bin \
  && mv packer-* /usr/local/bin \
  && cd /tmp \
  && rm -rf packer

# Install terraform to /usr/local/bin
RUN mkdir -p /tmp/terraform \
  && cd /tmp/terraform \
  && wget --no-verbose https://releases.hashicorp.com/terraform/0.7.6/terraform_0.7.6_linux_amd64.zip \
  && unzip terraform_0.7.6_linux_amd64.zip \
  && rm terraform*.zip \
  && mv terraform* /usr/local/bin \
  && cd /tmp \
  && rm -rf terraform

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
  && apt-get install -y python3 python3-dev python3-pip python3-virtualenv \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install a bunch of utilities through pip
RUN pip install awscli virtualenv boto dopy cookiecutter requests

# Install the released version of ansible
RUN apt-get -qq update \
  && apt-add-repository -y ppa:ansible/ansible \
  && apt-get -qq update \
  && apt-get install -y ansible \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

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
  && wget --no-verbose http://apache.mirror.rafal.ca/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz \
  && tar xzf apache-maven-3.6.1-bin.tar.gz \
  && mv apache-maven-3.6.1 /usr/share/maven3 \
  && update-alternatives --install /usr/bin/mvn mvn /usr/share/maven3/bin/mvn 1 \
  && update-alternatives --set mvn /usr/share/maven3/bin/mvn \
  && cd /tmp \
  && rm -rf maven \
  && /usr/bin/printf '\xfe\xed\xfe\xed\x00\x00\x00\x02\x00\x00\x00\x00\xe2\x68\x6e\x45\xfb\x43\xdf\xa4\xd9\x92\xdd\x41\xce\xb6\xb2\x1c\x63\x30\xd7\x92' > /etc/ssl/certs/java/cacerts \
  && /var/lib/dpkg/info/ca-certificates-java.postinst configure

# Install ruby 2.3
RUN apt-get -qq update \
  && apt-get install -y ruby2.3 ruby2.3-dev zlib1g-dev \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install a few gems
RUN gem install travis bundle reckon --no-rdoc --no-ri

# Install the lego letsencrypt client
RUN mkdir -p /tmp/lego \
  && cd /tmp/lego \
  && wget --no-verbose -O lego.tar.xz https://github.com/xenolf/lego/releases/download/v0.3.1/lego_linux_amd64.tar.xz \
  && tar xf lego.tar.xz \
  && mv lego/lego /usr/local/bin/ \
  && cd /tmp \
  && rm -rf lego

# Install git-lfs
RUN curl -L https://packagecloud.io/github/git-lfs/gpgkey | sudo apt-key add - \
  && apt-get -qq update \
  && echo "deb https://packagecloud.io/github/git-lfs/ubuntu/ xenial main" >> /etc/apt/sources.list.d/github_git-lfs.list \
  && apt-get -qq update \
  && apt-get install -y git-lfs \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install the diff-highlight script
RUN mkdir -p /root/bin \
  && wget -O /root/bin/diff-highlight https://raw.githubusercontent.com/git/git/fd99e2bda0ca6a361ef03c04d6d7fdc7a9c40b78/contrib/diff-highlight/diff-highlight \
  && chown root: /root/bin/diff-highlight \
  && chmod +x /root/bin/diff-highlight

# Install the yarn package manager
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list \
  && apt-get -qq update \
  && apt-get install -y yarn \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install the yarn bash completion script
RUN wget --no-verbose -O /etc/bash_completion.d/yarn https://raw.githubusercontent.com/dsifford/yarn-completion/v0.6.1/yarn-completion.bash

# Utilities needed for gopro video & image processing
RUN apt-get -qq update \
  && apt-add-repository -y ppa:mc3man/ffmpeg-test \
  && apt-get -qq update \
  && apt-get install -y \
    ffmpeg-static \
    exiftool \
    sox \
    libsox-fmt-all \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
  && wget --no-verbose -O /usr/local/bin/fredim-autocolor "http://www.fmwconcepts.com/imagemagick/downloadcounter.php?scriptname=autocolor&dirname=autocolor" \
  && chmod 0755 /usr/local/bin/fredim-autocolor \
  && wget --no-verbose -O /usr/local/bin/fredim-enrich "http://www.fmwconcepts.com/imagemagick/downloadcounter.php?scriptname=enrich&dirname=enrich" \
  && chmod 0755 /usr/local/bin/fredim-enrich

# Install 1password cli
RUN mkdir -p /tmp/op \
  && cd /tmp/op \
  && wget --no-verbose https://cache.agilebits.com/dist/1P/op/pkg/v0.5.6-003/op_linux_amd64_v0.5.6-003.zip \
  && unzip op_linux_amd64_v0.5.6-003.zip \
  && rm op*.zip \
  && mv op /usr/local/bin \
  && cd /tmp \
  && rm -rf op

# Install docker compose within the container
RUN curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose

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
  && ln -s /var/shared/.vim \
  && ln -s /var/shared/.vimrc \
  && ln -s /var/shared/.gnupg \
  && ln -s /var/shared/.ngrok2 \
  && ln -s /var/shared/Dropbox/projects \
  && chown -R root: /root

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
ENV PATH /root/.gem/ruby/2.3.0/bin:$PATH
ENV PATH $NVM_DIR/version/node/v$NODE_VERSION/bin:$PATH
ENV NODE_PATH $NVM_DIR/version/node/v$NODE_VERSION/lib/node_modules

USER root

ENTRYPOINT "/bin/bash"
