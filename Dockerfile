From ubuntu:18.04

ARG MAVEN_VERSION=3.8.6

ARG USER_HOME_DIR="/root"

ARG SHA=f790857f3b1f90ae8d16281f902c689e4f136ebe584aba45e4b1fa66c80cba826d3e0e52fdd04ed44b4c66f6d3fe3584a057c26dfcac544a60b301e6d0f91c26

ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

Run apt-get update
RUN apt-get install -y wget

RUN wget --no-verbose -O /tmp/apache-maven-3.3.9-bin.tar.gz http://www-eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
    tar xzf /tmp/apache-maven-3.3.9-bin.tar.gz -C /opt/ && \
    ln -s /opt/apache-maven-3.3.9 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/local/bin  && \
    rm -f /tmp/apache-maven-3.3.9-bin.tar.gz

ENV MAVEN_HOME /opt/maven

RUN mkdir /opt/work

WORKDIR /opt/work

RUN apt-get update && apt-get install -y gnupg

RUN sh -c 'echo "deb https://packages.atlassian.com/debian/atlassian-sdk-deb/ stable contrib" >>/etc/apt/sources.list'

RUN wget https://packages.atlassian.com/api/gpg/key/public

RUN apt-key add public

RUN apt-get update

RUN apt-get install atlassian-plugin-sdk

RUN apt install openjdk-11-jdk -y

CMD  while true; do sleep 5; done 
