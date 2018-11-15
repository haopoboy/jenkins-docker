FROM jenkins/jenkins:2.138.3-alpine

USER root

# Add node
ENV NODE_VERSION 8.11.4
RUN apk add --no-cache npm="$NODE_VERSION"-r0

# Add docker
ADD https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz /tmp
RUN tar -xvzf /tmp/docker-latest.tgz && \
    mv docker/* /usr/bin/ && \
    chmod +x /usr/bin/docker && \
    rm -f /tmp/docker-latest.tgz

RUN addgroup $USER docker
RUN addgroup jenkins docker

# Add kubectl & helm
WORKDIR /usr/local/bin
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x kubectl \
    && apk add --update --no-cache ca-certificates openssl \
    && curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
    

# Back to Jenkins home
USER jenkins
WORKDIR $JENKINS_HOME
