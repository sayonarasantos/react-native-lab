FROM ubuntu:20.04

LABEL version="1.0" description="React native - environment to build apk" maintainer="Sayonara Santos<sayyonarasantos@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ARG NODE_VERSION=12.x
ARG SDK_LINK=https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV ANDROID_HOME=/opt/Android
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# Install general packages
RUN apt-get update -qq -y \
    && apt-get install -qq -y --no-install-recommends \
       apt-utils \
       software-properties-common \
       curl \
       unzip \
       gpg-agent \
    && rm -rf /var/lib/apt/lists/*

# Install Nodejs, Yarn and JDK
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && add-apt-repository ppa:openjdk-r/ppa \
    && apt-get update -qq -y \
    && apt-get install -qq -y --no-install-recommends \
       nodejs \
       yarn \
       openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/*

# Create user
RUN useradd -mr -d /project beyonce \
    && mkdir ${ANDROID_HOME} -p \
    && chown beyonce:beyonce ${ANDROID_HOME} -R

USER beyonce

# Install Android SDK 
RUN mkdir ${ANDROID_HOME}/cmdline-tools -p \
    && curl -sS ${SDK_LINK} -o ${ANDROID_HOME}/sdk.zip \
    && unzip -qq -d ${ANDROID_HOME}/cmdline-tools ${ANDROID_HOME}/sdk.zip \
    && rm ${ANDROID_HOME}/sdk.zip \
    && yes | sdkmanager "tools" \
    && rm -rf ${ANDROID_HOME}/.android

# Set working diretory
WORKDIR /project

# Copy project files
COPY --chown=beyonce:beyonce . /project
