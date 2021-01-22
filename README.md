# Docker OpenWrt Builder

Build [OpenWrt](https://openwrt.org/) images in a Docker container. This is sometimes necessary when building OpenWrt on the host system fails, e.g. when some dependency is too new. The docker image is based on Debian 10 (Buster).

Build tested:

- OpenWrt-19.07.6

## Prerequisites

* Docker installed
* running Docker daemon
* build Docker image:

```
git clone git@bitbucket.org:steffenscheib/docker-openwrt_builder.git
cd docker-openwrt_builder
docker build -t openwrt_builder .
```

Now the docker image is available. These steps only need to be done once.
By default UID and GID are mapped to 1003 - check ARG statements in the Dockerfile.

## Usage GNU/Linux

Create a build folder and link it into a new docker container:
```
docker run --name build.wrt3200acm --hostname build.pve.ext.scheib.me -v /build/openwrt-source/:/home/builder -it openwrt_builder /bin/bash
```

In the container console, enter:
```
git clone https://git.openwrt.org/openwrt/openwrt.git
cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
make download
make -j"$(nproc)"
```

## Restarting the docker container
The docker container can (obviously) be re-used everytime:
```
root@build:/home/steffen# docker ps -a
CONTAINER ID   IMAGE             COMMAND       CREATED          STATUS                        PORTS     NAMES
c72a2addcc00   openwrt_builder   "/bin/bash"   30 seconds ago   Exited (127) 18 seconds ago             build.wrt3200acm
root@build:/home/steffen# docker start c72a2addcc00
c72a2addcc00
root@build:/home/steffen# docker ps -a
CONTAINER ID   IMAGE             COMMAND       CREATED          STATUS         PORTS     NAMES
c72a2addcc00   openwrt_builder   "/bin/bash"   38 seconds ago   Up 2 seconds             build.wrt3200acm
root@build:/home/steffen# docker exec -it c72a2addcc00 /bin/bash
builder@build:~$ pwd
/home/builder
builder@build:~$ ls -la
total 1508
drwxr-xr-x 18 builder builder   4096 Jan 22 10:25 .
drwxr-xr-x  1 root    root        21 Jan 22 10:42 ..
-rw-------  1 builder builder    135 Jan 22 10:55 .bash_history
-rw-r--r--  1 builder builder 280557 Jan 21 20:02 .config
-rw-r--r--  1 builder builder 280546 Jan 21 19:27 .config.old
-rw-r--r--  1 builder builder 280937 Jan 21 12:28 .config_customized_busybox
-rw-r--r--  1 builder builder 247186 Jan 21 11:50 .config_final
-rw-r--r--  1 builder builder 290764 Jan 20 22:03 .config_wrt3200acm
drwxr-xr-x  8 builder builder    181 Jan 20 17:51 .git
-rw-r--r--  1 builder builder      8 Jan 20 16:54 .gitattributes
drwxr-xr-x  2 builder builder     57 Jan 20 16:54 .github
-rw-r--r--  1 builder builder    261 Jan 20 16:58 .gitignore
-rw-r--r--  1 builder builder    179 Jan 20 16:54 BSDmakefile
-rw-r--r--  1 builder builder    576 Jan 20 16:54 Config.in
-rw-r--r--  1 builder builder  17992 Jan 20 16:58 LICENSE
-rw-r--r--  1 builder builder   3740 Jan 20 16:58 Makefile
-rw-r--r--  1 builder builder   1295 Jan 20 16:58 README
drwxr-xr-x  4 builder builder     37 Jan 20 18:05 bin
drwxr-xr-x  5 builder builder     94 Jan 21 20:44 build_dir
drwxr-xr-x  2 builder builder    100 Jan 20 16:58 config
drwxr-xr-x  2 builder builder  12288 Jan 21 20:16 dl
drwxr-xr-x 12 builder builder   4096 Jan 20 17:00 feeds
-rw-r--r--  1 builder builder    502 Jan 20 16:58 feeds.conf.default
drwxr-xr-x  6 builder builder     55 Jan 21 19:18 files
drwxr-xr-x  3 builder builder   4096 Jan 20 16:58 include
-rw-r--r--  1 builder builder    176 Jan 20 18:16 key-build
-rw-r--r--  1 builder builder     92 Jan 20 18:16 key-build.pub
-rw-r--r--  1 builder builder    356 Jan 20 18:16 key-build.ucert
-rw-r--r--  1 builder builder    260 Jan 20 18:16 key-build.ucert.revoke
drwxr-xr-x 12 builder builder    162 Jan 20 17:00 package
-rw-r--r--  1 builder builder  13370 Jan 20 16:58 rules.mk
drwxr-xr-x  4 builder builder   4096 Jan 20 16:58 scripts
drwxr-xr-x  5 builder builder     94 Jan 21 20:44 staging_dir
drwxr-xr-x  6 builder builder    100 Jan 20 16:58 target
drwxr-xr-x  4 builder builder  16384 Jan 21 20:22 tmp
drwxr-xr-x 12 builder builder    203 Jan 20 16:58 toolchain
drwxr-xr-x 61 builder builder   4096 Jan 20 16:58 tools
-rw-r--r--  1 builder builder     18 Jan 20 16:58 version
-rw-r--r--  1 builder builder     11 Jan 20 16:58 version.date
builder@build:~$ 
```

After the build, the images will be inside `/build/openwrt/bin/target/`.

Forked and modified from: https://github.com/mwarning/docker-openwrt-builder
