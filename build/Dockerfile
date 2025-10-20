FROM python:trixie AS base

# Copy Java from openjdk:26-oracle
ENV JAVA_HOME=/usr/java/openjdk-26
COPY --from=openjdk:26-oracle $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Copy Gradle from gradle:latest
ENV GRADLE_HOME=/opt/gradle
COPY --from=gradle:latest $GRADLE_HOME $GRADLE_HOME
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

FROM base AS requirements

# Install Python Packages
RUN pip3 install \
    requests \
    rich \
    ipykernel

FROM requirements AS scala

# Install Scala
ARG SCALA_VERSION="3.7.3"
ARG URL="https://github.com/scala/scala3/releases/download/${SCALA_VERSION}/scala3-${SCALA_VERSION}.tar.gz"
ARG SCALA_DIR="/usr/share/scala3-${SCALA_VERSION}"
RUN curl -fsL --show-error ${URL} | tar xfz - -C /usr/share && \
	mv ${SCALA_DIR} /usr/share/scala && \
	chown -R root:root /usr/share/scala && \
	chmod -R 755 /usr/share/scala && \
	ln -s /usr/share/scala/bin/* /usr/local/bin

# Install Gradle
# ARG GRADLE_VERSION="9.1.0"
# RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp
# RUN unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip
# RUN ln -s /opt/gradle/gradle-${GRADLE_VERSION} /opt/gradle/latest
# ENV GRADLE_HOME=/opt/gradle/latest
# ENV PATH=$PATH:$GRADLE_HOME/bin

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