# Install ubuntu
FROM ubuntu:14.04

# Update and upgrade
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# Install tools
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	nano \
	wget \
	git \
	unzip

# Install Boring Man and bmanage
RUN dpkg --add-architecture i386
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	software-properties-common
RUN add-apt-repository -y ppa:ubuntu-wine/ppa && apt-get update -y
RUN git clone https://github.com/aldencolerain/bmanage
WORKDIR bmanage
RUN bash bmanage.sh install examplepassword
