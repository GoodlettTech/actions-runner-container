FROM ubuntu:20.04

ARG RUNNER_VERSION="2.315.0"

ENV DEBIAN_FRONTEND=noninteractive

VOLUME ["/work"]

RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

RUN apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip docker.io

RUN cd /home/docker \
	&& mkdir actions-runner \
	&& cd actions-runner \
	&& curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
	&& tar xzf ./actions-runner.tar.gz

RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

COPY start.sh start.sh

RUN chmod +x start.sh

USER docker

ENV REPO_SLUG=""
ENV TOKEN=""

ENTRYPOINT ["./start.sh"]
