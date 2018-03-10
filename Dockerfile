FROM jenkins/jenkins:2.89.4-alpine

USER root

# Add node
ENV NODE_VERSION 8.10.0
RUN apk add --no-cache nodejs="$NODE_VERSION"-r0

# Add docker
ADD https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz /tmp
RUN tar -xvzf /tmp/docker-latest.tgz && \
    mv docker/* /usr/bin/ && \
    chmod +x /usr/bin/docker && \
    rm -f /tmp/docker-latest.tgz

RUN addgroup $USER docker
RUN addgroup jenkins docker

# Add kubectl
WORKDIR /usr/local/bin
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x kubectl

# Back to Jenkins home
USER jenkins
WORKDIR $JENKINS_HOME
