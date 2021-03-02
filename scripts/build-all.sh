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
  --suffix='87 latest' \
  --build-arg 'from_tag=fermium'

# ./scripts/build-image.sh --push --readme \
#   --df=cypress \
#   --tag='fermium-cypress-5.5.0' \
#   --build-arg 'cypress_version=5.5.0' \
#   --build-arg 'from_tag=fermium'

./scripts/build-image.sh --push --readme \
  --df=release-cli \
  --tag='release-cli' \
  --suffix='latest'

./scripts/build-image.sh --push --readme \
  --df=cypress \
  --tag='fermium-cypress' \
  --suffix='latest 5.6.0' \
  --build-arg 'cypress_version=5.6.0' \
  --build-arg 'from_tag=fermium'

## angular 10.1.1
#

# ./scripts/build-image.sh --push \
#   --df=ng \
#   --tag=erbium-ng-10.1.1  \
#   --build-arg 'angular_cli_version=10.1.1' \
#   --build-arg 'from_tag=erbium'

# ./scripts/build-image.sh --push \
#   --df=ng \
#   --tag='erbium-chrome-ng-10.1.1' \
#   --build-arg 'angular_cli_version=10.1.1' \
#   --build-arg 'from_tag=erbium-chrome'


## Angular 11.0.2
#
./scripts/build-image.sh --push --readme \
  --df=ng \
  --tag=fermium-ng  \
  --suffix='11.0.2 latest' \
  --build-arg 'angular_cli_version=11.0.2' \
  --build-arg 'from_tag=fermium'

./scripts/build-image.sh --push --readme \
  --df=ng \
  --tag='fermium-chrome-ng' \
  --suffix='11.0.2 latest' \
  --build-arg 'angular_cli_version=11.0.2' \
  --build-arg 'from_tag=fermium-chrome'

./scripts/build-image.sh --push --readme \
  --df=ng \
  --tag=fermium-cypress-ng \
  --suffix='11.0.2 latest' \
  --build-arg 'angular_cli_version=11.0.2' \
  --build-arg 'from_tag=fermium-cypress'

## Angular 10.1.1
#
# ./scripts/build-image.sh --push \
#   --df=ng \
#   --tag=fermium-ng-10.1.1  \
#   --build-arg 'angular_cli_version=10.1.1' \
#   --build-arg 'from_tag=fermium'

# ./scripts/build-image.sh --push \
#   --df=ng \
#   --tag='fermium-chrome-ng-10.1.1' \
#   --build-arg 'angular_cli_version=10.1.1' \
#   --build-arg 'from_tag=fermium-chrome'

## angular 10.2.0
#
# ./scripts/build-image.sh --push \
#   --df=ng \
#   --tag=fermium-ng \
#   --suffix='10.2.0 latest' \
#   --build-arg 'angular_cli_version=10.2.0' \
#   --build-arg 'from_tag=fermium'

# ./scripts/build-image.sh --push \
#   --df=ng \
#   --tag=fermium-chrome-ng \
#   --suffix='10.2.0 latest' \
#   --build-arg 'angular_cli_version=10.2.0' \
#   --build-arg 'from_tag=fermium-chrome'

# ./scripts/build-image.sh --push \
#   --df=ng \
#   --tag=fermium-cypress-ng \
#   --suffix='10.2.0 latest' \
#   --build-arg 'angular_cli_version=10.2.0' \
#   --build-arg 'from_tag=fermium-cypress'
