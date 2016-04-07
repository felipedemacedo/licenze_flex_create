FROM buildpack-deps:wheezy-scm

RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8
ENV JAVA_VERSION 6b35
ENV JAVA_DEBIAN_VERSION 6b38-1.13.10-1~deb7u1

RUN apt-get update -y && apt-get install --no-install-recommends -y -q curl python build-essential git ca-certificates
RUN mkdir /nodejs && curl http://nodejs.org/dist/v0.10.33/node-v0.10.33-linux-x64.tar.gz | tar xvzf - -C /nodejs --strip-components=1

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y openjdk-6-jdk:i386="$JAVA_DEBIAN_VERSION" && rm -rf /var/lib/apt/lists/*
RUN update-alternatives --set java /usr/lib/jvm/java-6-openjdk-i386/jre/bin/java

ENV PATH $PATH:/nodejs/bin

RUN npm install flex-sdk@3.6.0-0

ENV flexlib /node_modules/flex-sdk/lib/flex_sdk/frameworks
ENV PATH $PATH:/node_modules/flex-sdk/bin
ENV FLEX_HOME /node_modules/flex-sdk/lib/flex_sdk

ADD config-compiler.xml config/
ADD http://download.macromedia.com/pub/flex/sdk/automation_sdk3.6.zip config/
ADD http://download.macromedia.com/pub/flex/sdk/datavisualization_sdk3.5.zip config/
ADD compile.sh ./ 

RUN cd config && unzip automation_sdk3.6.zip -d automation_sdk/ && unzip datavisualization_sdk3.5.zip -d datavisualization_sdk/ && rm automation_sdk3.6.zip && rm datavisualization_sdk3.5.zip

RUN chmod 755 compile.sh && cp config/datavisualization_sdk/frameworks/libs/datavisualization.swc $flexlib/libs && cp config/datavisualization_sdk/frameworks/rsls/datavisualization_3.5.0.12683.sw* $flexlib/rsls && cp config/automation_sdk/libs/* $flexlib/libs && cp config/automation_sdk/locale/en_US/* $flexlib/locale/en_US/

CMD ["./compile.sh"]
