# Install Operating system and dependencies
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback python3 lsof && apt-get install -y dos2unix
RUN apt-get clean

ENV DEBIAN_FRONTEND=dialog
ENV PUB_HOSTED_URL=https://pub.dartlang.org
ENV FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com

# download Flutter SDK from Flutter Github repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
RUN cd /usr/local/flutter && git checkout stable
# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable flutter web
RUN flutter channel stable
RUN flutter upgrade
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter pub get
# RUN flutter config --no-explicit-package-dependencies
# RUN flutter pub add flutter_localizations --sdk=flutter
# RUN flutter pub add intl:any
RUN dos2unix /app/instal/entrypoint.sh

ARG BUILD_DATE
ARG DOCKER_TAG
RUN echo "BUILD_DATE=${BUILD_DATE}" > "/build_info.txt"
RUN echo "DOCKER_TAG=${DOCKER_TAG}" >> "/build_info.txt"
RUN flutter build web -v --dart-define=BUILD_DATE=${BUILD_DATE} --dart-define=DOCKER_TAG=${DOCKER_TAG}

# make server startup script executable and start the web server
RUN ["chmod", "+x", "/app/instal/entrypoint.sh"]

ENTRYPOINT [ "/app/instal/entrypoint.sh"]