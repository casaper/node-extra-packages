FROM node:erbium

ARG builddate

LABEL author="casaper (github.com/casaper)"

RUN apt update \
  && apt install -yqq --no-install-recommends rsync \
  && apt-get autoremove -yqq \
  && apt-get autoclean -yqq \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
