FROM debian:bullseye
ARG user=builder
ARG group=builder
ARG uid=2002
ARG gid=2002


RUN apt-get update &&\
    apt-get install -y sudo time git-core subversion build-essential g++ bash make libssl-dev patch libncurses5 libncurses5-dev zlib1g-dev gawk flex gettext wget unzip xz-utils python3 python3-distutils-extra rsync curl vim && \
    apt-get clean && \
    groupadd -g ${gid} ${group} && \
    useradd -m ${user} -u ${uid} -g ${gid} && \
    echo 'builder ALL=NOPASSWD: ALL' > /etc/sudoers.d/builder

USER builder
WORKDIR /home/builder

# set dummy git config
RUN git config --global user.name "builder" && git config --global user.email "builder@build.pve.ext.scheib.me"
