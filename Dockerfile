FROM ubuntu:latest

# Updates and installs commons
RUN apt-get update \
	&& apt-get install -y \
	curl \
	git \
	sudo \
	vim \
	wget \
	locales

# Install Python
RUN apt-get install -y \
	python3 \
	python3-tk \
	python-is-python3

# Install JAVA
RUN apt-get install -y \
	default-jdk \
	openjdk-21-source

# Install Scala
ARG SCALA_VERSION="3.6.3"
ARG URL="https://github.com/scala/scala3/releases/download/${SCALA_VERSION}/scala3-${SCALA_VERSION}.tar.gz"
ARG SCALA_DIR="/usr/share/scala3-${SCALA_VERSION}"
RUN curl -fsL --show-error ${URL} | tar xfz - -C /usr/share && \
	mv ${SCALA_DIR} /usr/share/scala && \
	chown -R root:root /usr/share/scala && \
	chmod -R 755 /usr/share/scala && \
	ln -s /usr/share/scala/bin/* /usr/local/bin

# Install R
RUN apt-get install -y \
	r-base \
	build-essential \
	libcurl4-openssl-dev \
	libssl-dev \
	libxml2-dev \
	libfontconfig1-dev
    # && Rscript -e 'install.packages(c("languageserver", "ggplot2", "reshape2", "httpgd"))'

# Install TeX-live
# RUN apt-get install -y texlive-full

# Clears apt lists
RUN rm -rf /var/lib/apt/lists/* 

# Sets local
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8

# Adds the default User
ARG USER=lth-student
RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}

# Sets user and work directory
USER ${USER}
WORKDIR /home/${USER}
