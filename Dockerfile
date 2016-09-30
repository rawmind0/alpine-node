FROM rawmind/alpine-monit:0.5.19-2
MAINTAINER Raul Sanchez <rawmind@gmail.com>

# ENV VERSION=v0.10.46 CFLAGS="-D__USE_MISC" NPM_VERSION=2
# ENV VERSION=v0.12.15 NPM_VERSION=2
# ENV VERSION=v4.4.7 NPM_VERSION=2
# ENV VERSION=v5.12.0 NPM_VERSION=3
# ENV VERSION=v6.3.1 NPM_VERSION=3

ENV SERVICE_NAME=node                                       \
    SERVICE_HOME=/opt/node                                  \
    SERVICE_VERSION=v5.12.0                                 \
    NPM_VERSION=3
ENV PATH=${SERVICE_HOME}/bin:${PATH}                        \
    SERVICE_CONF=${SERVICE_HOME}/etc/haproxy.cfg            \
    SERVICE_URL=https://nodejs.org/dist/${SERVICE_VERSION}  \ 
    SERVICE_RELEASE=node-${SERVICE_VERSION}                 \
    CONFIG_FLAGS="--fully-static --without-npm"             \
    DEL_PKGS="libgcc libstdc++"                             \
    RM_DIRS="/opt/src /usr/include"

RUN apk add --no-cache curl make gcc g++ python linux-headers paxctl libgcc libstdc++ gnupg && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys \
      9554F04D7259F04124DE6B476D5A82AC7E37093B \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
      FD3A5288F042B6850C66B31F09FE44734EB7990E \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      B9AE9905FFD7803F25714661B63B535A4C206CA9 && \
    mkdir -p /opt/src; cd /opt/src && \
    curl -O -sSL ${SERVICE_URL}/${SERVICE_RELEASE}.tar.gz && \
    curl -O -sSL ${SERVICE_URL}/SHASUMS256.txt.asc && \
    gpg --verify SHASUMS256.txt.asc && \
    grep ${SERVICE_RELEASE}.tar.gz SHASUMS256.txt.asc | sha256sum -c - && \
    tar -zxf ${SERVICE_RELEASE}.tar.gz && \
    cd ${SERVICE_RELEASE} && \
    export GYP_DEFINES="linux_use_gold_flags=0" && \
    ./configure --prefix=${SERVICE_HOME} ${CONFIG_FLAGS} && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    make -j${NPROC} -C out mksnapshot BUILDTYPE=Release && \
    paxctl -cm out/Release/mksnapshot && \
    make -j${NPROC} && \
    make install && \
    paxctl -cm ${SERVICE_HOME}/bin/node && \
    cd / && \
    if [ -x ${SERVICE_HOME}/bin/npm ]; then \
      npm install -g npm@${NPM_VERSION} && \
      find ${SERVICE_HOME}/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
    fi && \
    apk del curl make gcc g++ python linux-headers paxctl gnupg ${DEL_PKGS} && \
    rm -rf /etc/ssl \
      ${RM_DIRS} \
      /usr/share/man \
      /tmp/* \
      /var/cache/apk/* \
      /root/.npm \
      /root/.node-gyp \
      /root/.gnupg \
      ${SERVICE_HOME}/lib/node_modules/npm/man \
      ${SERVICE_HOME}/lib/node_modules/npm/doc \
      ${SERVICE_HOME}/lib/node_modules/npm/html
