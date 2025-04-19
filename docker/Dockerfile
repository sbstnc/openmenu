ARG ALPINE_VERSION="3.21.3"

FROM alpine:${ALPINE_VERSION}

ARG USER_NAME="dev"
ARG USER_GROUP="dev"

RUN apk add \
  --no-cache \
  --update \
  bash \
  build-base \
  cmake \
  curl \
  elfutils-dev \
  git \
  gmp-dev \
  libjpeg-turbo-dev \
  libpng-dev \
  mpc1-dev \
  mpfr-dev \
  patch \
  python3 \
  ruby-rake \
  texinfo \
  wget

RUN addgroup --system ${USER_GROUP} && \
  adduser --system --ingroup ${USER_GROUP} --shell /bin/bash ${USER_NAME} && \
  mkdir -p /opt/toolchains/dc && \
  chmod -R 755 /opt/toolchains/dc && \
  chown -R ${USER_NAME}:${USER_GROUP} /opt/toolchains/dc

USER ${USER_NAME}:${USER_GROUP}

WORKDIR /opt/toolchains/dc

RUN mkdir /opt/toolchains/dc/kos && \
  cd /opt/toolchains/dc/kos && \
  git init && \
  git remote add origin https://github.com/KallistiOS/KallistiOS.git && \
  git fetch --depth 1 origin ae3d5ec3ed7bbc0f0ea8fdd9f8d25e68ba7e8673 && \
  git checkout FETCH_HEAD

RUN cd /opt/toolchains/dc/kos/utils/dc-chain && \
  mv config.mk.testing.sample config.mk && \
  sed -i 's/#force_downloader=wget/force_downloader=wget/' config.mk && \
  ./download.sh && \
  ./unpack.sh && \
  make && \
  ./cleanup.sh

COPY kos_patch/fs_iso9660.c ./kos/kernel/arch/dreamcast/fs/fs_iso9660.c

RUN cd /opt/toolchains/dc/kos && \
  cp doc/environ.sh.sample environ.sh && \
  source /opt/toolchains/dc/kos/environ.sh && \
  make

WORKDIR /home/${USER_NAME}
RUN touch .bashrc && echo "source /opt/toolchains/dc/kos/environ.sh" >> .bashrc

ARG BUILD_DATE
ARG IMAGE_URL
ARG IMAGE_VERSION
ARG VCS_REF
ARG VCS_URL

LABEL org.opencontainers.image.title="openMenu DevContainer" \
  org.opencontainers.image.description="A Docker image that provides a development environment for building openMenu." \
  org.opencontainers.image.authors="ockenfels.fabian@gmail.com" \
  org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.url=$IMAGE_URL \
  org.opencontainers.image.version=$IMAGE_VERSION \
  org.opencontainers.image.revision=$VCS_REF \
  org.opencontainers.image.source=$VCS_URL

CMD ["/bin/bash"]
