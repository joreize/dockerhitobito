FROM ubuntu:bionic

# Configure shell
SHELL [ "bash", "-x", "-e", "-c" ]

# OS Prereq install
RUN apt-get update \
 && apt-get -y install apt-utils \
 && echo "Europe/Berlin" > /etc/timezone \
 && ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
 && apt-get -y install \
        ca-certificates \
        apt-transport-https \
        software-properties-common \
        curl \
        wget \
        openssl \
        unzip \
        jq \
        git \
        language-pack-en \
        zip \
        ruby-full \
        ruby-bundler \
        ruby-dev \
        sqlite3 \
        libsqlite3-dev \ 
        libgmp3-dev \
        mysql-client \
        libmysqlclient-dev \
        mysql-server \
        sphinxsearch \
        memcached \
        imagemagick \
        transifex-client \
        graphviz \
        git \ 
        patch ruby-dev \
        zlib1g-dev\
        libxml2-dev \
        libxml2 \
        libxslt-dev \
        pkg-config \
        libz-dev \
        gcc \
        liblzma-dev \
        tzdata \
 && update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX \
 && locale-gen

RUN mkdir /hitobito

WORKDIR /hitobito

RUN git clone https://github.com/hitobito/hitobito.git \
 && git clone https://github.com/hitobito/hitobito_generic.git \
 && cp hitobito/Wagonfile.ci hitobito/Wagonfile \
 && cp hitobito/Gemfile.lock hitobito_generic/

WORKDIR /hitobito/hitobito

RUN gem update --system

RUN gem install rake

RUN gem install rubocop \
 && gem install tzinfo \
 && gem install tzinfo-data

RUN rm Gemfile.lock

RUN bundle install

RUN bundle \
 && rake db:create \
# && rake db:setup:all \
# && gem install foreman \
# && foreman start

#RUN rake \
# && rake wagon:test

