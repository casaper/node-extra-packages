ARG from_tag="erbium"
FROM node:${from_tag}

LABEL description="Node LTS Erbium base image with dependencies for installing several deb dependencies"
LABEL author="casaper (github.com/casaper)"

ARG etra_packages="rsync git"

RUN apt-get update && apt-get -qqy --no-install-recommends  \
    apt-transport-https \
    ca-certificates \
    gnupg \
    curl \
    rsync \
  && for package in $(echo "${etra_packages}" | tr ' ' "\n"); do apt-get install -qqy  --no-install-recommends "$package"; done \
  # cleanup caches
  && apt-get autoremove -yqq \
  && apt-get autoclean -yqq  \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
