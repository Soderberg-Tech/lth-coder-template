FROM ubuntu:latest AS base

# Copy Gradle from gradle:latest
COPY --from=gradle:latest /opt/gradle /opt/gradle
ENV GRADLE_HOME=/opt/gradle
ENV PATH="${GRADLE_HOME}/bin:${PATH}"

# Update and install dependencies
RUN apt-get -y update
RUN apt-get install -y \
	curl \
	git \
	sudo \
	vim \
	wget \
	unzip \
	locales

# Sets local
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8

FROM base AS python-init

# Install Python
RUN apt-get install -y \
	python3 \
    python3-pip \
    python3-venv \
	python3-tk \
	python-is-python3

# Install Python Packages
RUN pip install \
    requests \
    rich \
    ipykernel \
	--break-system-packages

FROM python-init AS java-init

# Install JAVA
RUN apt-get install -y \
	default-jdk \
	openjdk-21-source

FROM java-init AS scala

# Install Scala
ARG SCALA_VERSION="3.7.3"
ARG URL="https://github.com/scala/scala3/releases/download/${SCALA_VERSION}/scala3-${SCALA_VERSION}.tar.gz"
ARG SCALA_DIR="/usr/share/scala3-${SCALA_VERSION}"
RUN curl -fsL --show-error ${URL} | tar xfz - -C /usr/share && \
	mv ${SCALA_DIR} /usr/share/scala && \
	chown -R root:root /usr/share/scala && \
	chmod -R 755 /usr/share/scala && \
	ln -s /usr/share/scala/bin/* /usr/local/bin

FROM scala AS lth

# Clears apt lists
RUN rm -rf /var/lib/apt/lists/* 

# Adds the default User
ARG USER=lth-student
RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}

# Sets user and work directory
USER ${USER}
WORKDIR /home/${USER}
ENV PATH="${GRADLE_HOME}/bin:${PATH}"