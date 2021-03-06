ARG from_tag="fermium-slim"
FROM node:${from_tag}

# define extra debian packages to install separated by `;`
ARG extra_packages

ARG app_directory="/app"

LABEL description="Node LTS Fermium base image with dependencies for installing several deb dependencies"
LABEL author="casaper" extra_packages=$extra_packages

ENV NPM_CONFIG_LOGLEVEL=warn NG_CLI_ANALYTICS=false

WORKDIR $app_directory

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

RUN apt-get update \
  && apt-get install -yq --no-install-recommends \
                build-essential \
                ca-certificates \
                curl \
                dumb-init \
                git \
                openssh-client \
                procps \
                rsync \
                zip \
                python3 \
                unzip \
                $(echo "$extra_packages" | tr ';' "\n") \
  && set -xe \
  && npm install -g npm@latest \
  && mkdir -p "$app_directory" \
  && chown node:node "$app_directory" \
  && chmod a+rw "$app_directory" \
  && chown -R node:node \
                /usr/local/lib \
                /usr/local/include \
                /usr/local/share \
                /usr/local/bin \
  # cleanup caches
  && apt-get autoremove -yq \
  && apt-get autoclean -yq  \
  && rm -rf \
          /var/lib/apt/lists/* \
          /tmp/* \
          /var/tmp/*
