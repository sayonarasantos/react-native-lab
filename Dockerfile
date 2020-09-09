FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV ANDROID_HOME=/opt/Android
ENV ANDROID_SDK_HOME=${ANDROID_HOME}
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# Install dependencies 
RUN apt-get update -qq -y && apt-get install -qq -y --no-install-recommends \
    apt-utils \
    software-properties-common \
    curl \
    unzip \
    gpg-agent

# Prepare container to install Nodejs, Yarn and JDK 
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN add-apt-repository ppa:openjdk-r/ppa

# Install Nodejs, Yarn and JDK
RUN apt-get update -qq -y && apt-get install -qq -y --no-install-recommends \
    nodejs \
    yarn \
    openjdk-8-jdk

# Install Android SDK 
RUN mkdir ${ANDROID_HOME} && mkdir ${ANDROID_HOME}/cmdline-tools && \
    curl -sS https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip -o ${ANDROID_HOME}/sdk.zip && \
    unzip -qq -d ${ANDROID_HOME}/cmdline-tools ${ANDROID_HOME}/sdk.zip && \
    rm ${ANDROID_HOME}/sdk.zip && \
    yes | sdkmanager "tools"

# Create projects directory
RUN mkdir -p /home/projects
