ARG AWSCLI_VERSION=2.2.30
ARG PYTHON_VERSION=3.9
ARG NODEJS=14.x

FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ARG AWSCLI_VERSION
ARG PYTHON_VERSION
ARG NODEJS

WORKDIR /root

RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    ca-certificates \
    curl \
    docker.io \
    git \
    gpg \
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
    pip install pipenv && \
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python -

RUN \
    mkdir -p /root/.docker/cli-plugins && \
    wget --output-document=/root/.docker/cli-plugins/docker-buildx https://github.com/docker/buildx/releases/download/v0.6.3/buildx-v0.6.3.linux-amd64 && \
    chmod +x /root/.docker/cli-plugins/docker-buildx && \
    docker buildx install

RUN \
    pip install git+git://github.com/aws/aws-cli.git#$AWSCLI_VERSION && \
    aws configure set cli_follow_urlparam false

RUN \
    curl -fsSL https://deb.nodesource.com/setup_$NODEJS | bash && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y nodejs yarn && \
    npm i -g npm@^6 && \
    apt-mark hold nodejs

RUN \
    npm install -g serverless

ENV LANG=C.UTF-8
ENV POETRY_HOME=/usr/local
