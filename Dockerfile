FROM ubuntu:latest
LABEL maintainer="gid@starberry.tv"

RUN echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup \
    && echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean \
    && echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean \
    && echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean \
    && echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages \
    && echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes

COPY debconf.txt /tmp

RUN debconf-set-selections < /tmp/debconf.txt

RUN DEBIAN_FRONTEND=noninteractive \
       apt-get update \
    && apt-get install -y apt-utils \
    && apt-get install -y ubuntu-server openssh-server locales sudo zsh nano git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 22

RUN \
       locale-gen en_GB.UTF-8 en_US.UTF-8 \
    && update-locale LANG=en_GB.UTF-8 LC_COLLATE=C

COPY /etc/zsh/zsh* /etc/zsh/

RUN echo '%sudo ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/02_sudo_nopasswd

VOLUME /home

ARG user=me

RUN \
       ( echo | adduser --gecos ${user} --shell=/usr/bin/zsh --home=/home/${user} --uid=501 --disabled-password ${user} ) \
    && ( echo "${user}:the.dog.ate.my.homework" | chpasswd ) \
    && adduser ${user} sudo


VOLUME ["/sys/fs/cgroup", "/tmp", "/run", "/run/lock"]

CMD ["/sbin/init"]
