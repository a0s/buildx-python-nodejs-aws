ARG AWSCLI_VERSION=2.2.30
ARG PYTHON_VERSION=3.9

FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ARG AWSCLI_VERSION
ARG PYTHON_VERSION

WORKDIR /root

RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        curl \
        docker.io \
        git \
        groff \
        software-properties-common \
        wget

RUN \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt install --no-install-recommends -y \
        python${PYTHON_VERSION} \
        python${PYTHON_VERSION}-dev \
        python${PYTHON_VERSION}-distutils \
        python${PYTHON_VERSION}-venv && \
    update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 10 && \
    python -m ensurepip --upgrade && \
    update-alternatives --install /usr/local/bin/pip pip /usr/local/bin/pip${PYTHON_VERSION} 10 && \
    pip install pipenv

RUN \
    mkdir -p /root/.docker/cli-plugins && \
    wget --output-document=/root/.docker/cli-plugins/docker-buildx  https://github.com/docker/buildx/releases/download/v0.6.3/buildx-v0.6.3.linux-amd64 && \
    chmod +x /root/.docker/cli-plugins/docker-buildx && \
    docker buildx install

RUN \
    curl -fsSL https://deb.nodesource.com/setup_14.x | bash && \
    apt-get install -y nodejs yarn && \
    apt-mark hold nodejs

RUN \
    pip install git+git://github.com/aws/aws-cli.git#$AWSCLI_VERSION && \
    aws configure set cli_follow_urlparam false

RUN \
    npm install -g serverless

ENV LANG=C.UTF-8
