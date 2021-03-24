FROM nvidia/cuda:10.0-devel AS build
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -q -y update && \
    apt-get -q -y upgrade && \
    apt-get -q -y install \
    cmake \
    git \
    perl
RUN git clone --depth 1 https://github.com/ethereum-mining/ethminer.git /tmp/ethminer
WORKDIR /tmp/ethminer
RUN git submodule update --init --recursive 
WORKDIR /tmp/ethminer/build
RUN cmake .. -DETHASHCUDA=ON -DETHASHCL=OFF && \
    cmake --build .

FROM nvidia/cuda:10.0-runtime
COPY --from=build /tmp/ethminer/build/ethminer /opt/ethminer
ENTRYPOINT ["/opt/ethminer/ethminer"]
