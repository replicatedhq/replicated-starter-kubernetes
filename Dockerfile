FROM ubuntu:18.04

MAINTAINER Replicated <support@replicated.com>

RUN apt-get update
RUN apt-get -y install curl

RUN curl -fsSL https://github.com/replicatedhq/replicated/releases/download/v0.10.0/replicated_0.10.0_linux_amd64.tar.gz | tar xvzf -

ENTRYPOINT ["./replicated"]
