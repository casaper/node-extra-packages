#!/usr/bin/env bash

. ./scripts/lib.sh
. ./scripts/dock-functions.sh

# base image
./scripts/build-image.sh --push --readme \
  --tag='fermium' \
  --build-arg 'from_tag=fermium-slim'

./scripts/build-image.sh --push --readme \
  --df='express' \
  --tag='fermium-express' \
  --build-arg 'from_tag=fermium-slim'

./scripts/build-image.sh --push --readme \
  --df=chrome \
  --tag='fermium-chrome' \
  --suffix='91 latest' \
  --build-arg 'from_tag=fermium'

./scripts/build-image.sh --push --readme \
  --df=release-cli \
  --tag='release-cli' \
  --suffix='latest'

./scripts/build-image.sh --push --readme \
  --df=cypress \
  --tag='fermium-cypress' \
  --suffix='latest 7.7.0' \
  --build-arg 'cypress_version=7.7.0' \
  --build-arg 'from_tag=fermium'

## Angular 11.2.14
#
./scripts/build-image.sh --push --readme \
  --df=ng \
  --tag=fermium-ng  \
  --suffix='11.2.14 latest' \
  --build-arg 'angular_cli_version=11.2.14' \
  --build-arg 'from_tag=fermium'

./scripts/build-image.sh --push --readme \
  --df=ng \
  --tag='fermium-chrome-ng' \
  --suffix='11.2.14 latest' \
  --build-arg 'angular_cli_version=11.2.14' \
  --build-arg 'from_tag=fermium-chrome'

./scripts/build-image.sh --push --readme \
  --df=ng \
  --tag=fermium-cypress-ng \
  --suffix='11.2.14 latest' \
  --build-arg 'angular_cli_version=11.2.14' \
  --build-arg 'from_tag=fermium-cypress'

## Angular 12.1.1
#
./scripts/build-image.sh --push --readme \
  --df=ng \
  --tag=fermium-ng  \
  --suffix='12.1.1 latest' \
  --build-arg 'angular_cli_version=12.1.1' \
  --build-arg 'from_tag=fermium'

./scripts/build-image.sh --push --readme \
  --df=ng \
  --tag='fermium-chrome-ng' \
  --suffix='12.1.1 latest' \
  --build-arg 'angular_cli_version=12.1.1' \
  --build-arg 'from_tag=fermium-chrome'

./scripts/build-image.sh --push --readme \
  --df=ng \
  --tag=fermium-cypress-ng \
  --suffix='12.1.1 latest' \
  --build-arg 'angular_cli_version=12.1.1' \
  --build-arg 'from_tag=fermium-cypress'
