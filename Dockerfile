ARG CUDA_VERSION=11.4.2
ARG ETHMINER_COMMIT=ce52c74021b6fbaaddea3c3c52f64f24e39ea3e9
FROM nvidia/cuda:$CUDA_VERSION-devel-ubuntu20.04 AS build
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -q -y update && \
    apt-get -q -y install \
    cmake \
    git \
    perl \
    curl
RUN mkdir -p /root/.hunter/_Base/Download/Boost/1.66.0/075d0b4 \
    && curl -SL 'https://boostorg.jfrog.io/ui/api/v1/download?repoKey=main&path=release%252F1.66.0%252Fsource%252Fboost_1_66_0.7z' \
    --output /root/.hunter/_Base/Download/Boost/1.66.0/075d0b4/boost_1_66_0.7z
RUN git clone https://github.com/ethereum-mining/ethminer.git /tmp/ethminer
WORKDIR /tmp/ethminer
RUN git checkout $ETHMINER_COMMIT && git submodule update --init --recursive
WORKDIR /tmp/ethminer/build
RUN cmake .. -DETHASHCUDA=ON -DETHASHCL=OFF && \
    cmake --build .

FROM nvidia/cuda:$CUDA_VERSION-runtime-ubuntu20.04
COPY --from=build /tmp/ethminer/build/ethminer /opt/ethminer
ENTRYPOINT ["/opt/ethminer/ethminer"]
