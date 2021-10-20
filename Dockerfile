ARG AWSCLI_VERSION=2.2.30

FROM ubuntu:20.04
WORKDIR /root

RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        curl \
        docker.io \
        git \
        groff \
        wget

RUN \
    mkdir -p /root/.docker/cli-plugins && \
    wget --output-document=/root/.docker/cli-plugins/docker-buildx  https://github.com/docker/buildx/releases/download/v0.6.3/buildx-v0.6.3.linux-amd64 && \
    chmod +x /root/.docker/cli-plugins/docker-buildx && \
    docker buildx install

RUN \
     apt install --no-install-recommends -y \
        python3 \
        python3-dev \
        python3-pip && \
     pip install -U pip && \
     pip install pipenv && \
     update-alternatives --install /usr/bin/python python /usr/bin/python3 10

RUN \
    curl -fsSL https://deb.nodesource.com/setup_14.x | bash && \
    apt-get install -y nodejs yarn && \
    apt-mark hold nodejs

RUN \
    pip install git+git://github.com/aws/aws-cli.git#$AWSCLI_VERSION && \
    aws configure set cli_follow_urlparam false

RUN \
    npm install -g serverless
