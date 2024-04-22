FROM ubuntu:20.04

ARG RUNNER_VERSION="2.315.0"
ENV DEBIAN_FRONTEND=noninteractive

VOLUME "/var/run/docker.sock"

RUN useradd -m docker

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y --no-install-recommends \
	curl \
	jq \
	build-essential \
	libssl-dev \
	libffi-dev \
	python3 \
	python3-venv \
	python3-dev \
	python3-pip \
	wget \
	gnupg2 \
	lsb-release \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update -y \
	&& apt-get install -y ca-certificates curl \
	&& install -m 0755 -d /etc/apt/keyrings \
	&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
	&& chmod a+r /etc/apt/keyrings/docker.asc \
	&& echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	tee /etc/apt/sources.list.d/docker.list > /dev/null \
	&& apt-get update -y \
	&& apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
	&& usermod -aG docker docker

RUN cd /home/docker \
	&& mkdir actions-runner \
	&& cd actions-runner \
	&& curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
	&& tar xzf ./actions-runner.tar.gz

RUN /home/docker/actions-runner/bin/installdependencies.sh

COPY start.sh start.sh
RUN chmod +x start.sh

RUN chown -R docker ~docker

USER docker
RUN newgrp docker

ENV REPO_SLUG=""
ENV TOKEN=""

ENTRYPOINT ["./start.sh"]
