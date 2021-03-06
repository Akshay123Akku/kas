# This image builds Yocto 2.1 and 2.2 jobs using the kas tool

FROM debian:jessie-slim

ENV LOCALE=en_US.UTF-8
RUN apt-get update && \
    apt-get install --no-install-recommends -y locales && \
    sed -i -e "s/# $LOCALE/$LOCALE/" /etc/locale.gen && \
    ln -s /etc/locale.alias /usr/share/locale/locale.alias && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    apt-get install --no-install-recommends -y \
                       gawk wget git-core diffstat unzip file \
                       texinfo gcc-multilib build-essential \
                       chrpath socat cpio python python3 rsync \
                       tar bzip2 curl dosfstools mtools parted \
                       syslinux tree python3-pip bc python3-yaml \
                       lsb-release python3-setuptools ssh-client \
                       vim less mercurial && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget -nv -O /usr/bin/gosu "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" && \
    chmod +x /usr/bin/gosu

RUN wget -nv -O /usr/bin/oe-git-proxy "http://git.yoctoproject.org/cgit/cgit.cgi/poky/plain/scripts/oe-git-proxy" && \
    chmod +x /usr/bin/oe-git-proxy
ENV GIT_PROXY_COMMAND="oe-git-proxy"
ENV NO_PROXY="*"

COPY . /kas
RUN pip3 --proxy=$https_proxy install /kas

ENV LANG=$LOCALE

ENTRYPOINT ["/kas/docker-entrypoint"]
