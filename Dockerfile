ARG UBUNTU_VERSION=22.04
ARG CUDA_VERSION=12.0.0
ARG GPUOWL_REFERENCE=main

# Target the CUDA build image
ARG BASE_CUDA_DEV_CONTAINER=nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}
# Target the CUDA runtime image
ARG BASE_CUDA_RUN_CONTAINER=nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu${UBUNTU_VERSION}

FROM ${BASE_CUDA_DEV_CONTAINER} as build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y git build-essential python3-minimal libgmp-dev libquadmath0 nvidia-opencl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/preda/gpuowl.git . && \
    git checkout ${GPUOWL_REFERENCE} && \ 
    make

FROM ${BASE_CUDA_RUN_CONTAINER} as runtime
ARG GPUOWL_REFERENCE

# NOTE(canardleteer): There is probably some OpenCL requirement lower than this that could be used.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y nvidia-opencl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /app /app

LABEL "org.opencontainers.image.title" "gpuowl CUDA" 
LABEL "org.opencontainers.image.licenses" "GPL-3.0"
# LABEL "org.opencontainers.image.version" ""
# LABEL "org.opencontainers.image.revision" ""
LABEL "org.opencontainers.image.url" "https://github.com/canardleteer/gpuowl-docker-cuda"

ENTRYPOINT [ "/app/build/gpuowl" ]
