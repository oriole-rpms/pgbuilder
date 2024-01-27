ARG DISTRO=dontknow
ARG DISTRO_RELEASE=dontcare
FROM ${DISTRO}:${DISTRO_RELEASE}

WORKDIR /usr/src/pgbuilder

COPY . .
RUN dnf install -y make && \
    make && \
    rm *

