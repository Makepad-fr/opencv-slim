ARG DEBIAN_TAG
FROM debian:${DEBIAN_TAG}

ARG OPENCV_VERSION

# hadolint ignore=DL3008
RUN apt-get update -y && \
    apt-get install -y cmake g++ git pkg-config ca-certificates build-essential --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone -q --depth 1 --branch ${OPENCV_VERSION} https://github.com/opencv/opencv.git

WORKDIR /app/build

RUN cmake -D CMAKE_BUILD_TYPE=Release \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D OPENCV_GENERATE_PKGCONFIG=ON ../opencv && \
    make -j"$(nproc)" && \
    make install && \
    ldconfig && \
    rm -rf /app/opencv && \
    rm -rf /app/build