# docker run --rm -ti -v $PWD:/opt/sources ubuntu:16.04 /bin/sh
FROM ubuntu:16.04 AS builder
MAINTAINER DIT168-GROUP9 github.com/dit168group9
RUN apt-get update && \
    apt-get install build-essential cmake -y && \
    apt-get install software-properties-common -y && \
    apt-add-repository ppa:chrberger/libcluon && \
    apt-get update && \
    apt-get install libcluon -y
ADD . /opt/sources
WORKDIR /opt/sources
RUN cd /opt/sources && \
    mkdir build && \
    cd build && \
    cmake -D CMAKE_BUILD_TYPE=Release .. && \
    make && \
    cd src/V2V/ && \
    cp GROUP9.V2V /tmp && \
    cd ../PS4Controller/ && \
    cp GROUP9.PS4Controller /tmp

# Deploy.
FROM ubuntu:16.04
MAINTAINER DIT168-GROUP9 github.com/dit168group9
RUN apt-get update && \
    apt-get install software-properties-common -y && \
    apt-add-repository ppa:chrberger/libcluon && \
    apt-get update && \
    apt-get install libcluon -y
WORKDIR /opt
COPY --from=builder /tmp/GROUP9.V2V .
COPY --from=builder /tmp/GROUP9.PS4Controller .
CMD ["/bin/sh"]
