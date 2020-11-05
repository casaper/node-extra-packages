#!/usr/bin/env bash

. ./scripts/lib.sh
. ./scripts/dock-functions.sh

while test $# -gt 0; do
  case "$1" in
  --push)
    PUSH_AFTER_BUILD=--push
    shift
    ;;
  *)
    break
    ;;
  esac
done


# base image
./scripts/build-image.sh ${PUSH_AFTER_BUILD} \
  --tag='fermium' \
  --build-arg=from_tag='fermium-slim'

./scripts/build-image.sh ${PUSH_AFTER_BUILD} \
  --df=chrome \
  --tag='fermium-chrome' \
  --suffix='86 latest' \
  --build-arg=from_tag='fermium'


./scripts/build-image.sh ${PUSH_AFTER_BUILD} \
  --df=cypress \
  --tag='fermium-cypress' \
  --suffix='latest 5.5.0' \
  --build-arg=cypress_version='5.5.0' \
  --build-arg=from_tag='fermium'

./scripts/build-image.sh ${PUSH_AFTER_BUILD} \
  --df=cypress \

  --tag='fermium-chrome-cypress' \
  --suffix='latest 5.5.0' \
  --build-arg=cypress_version='5.5.0' \
  --build-arg=from_tag='fermium-chrome'

## angular 10.1.1
#
./scripts/build-image.sh ${PUSH_AFTER_BUILD} \
  --df=ng \
  --tag=fermium-ng-10.1.1  \
  --build-arg=angular_cli_version='10.1.1' \
  --build-arg=from_tag='fermium'

./scripts/build-image.sh ${PUSH_AFTER_BUILD} \
  --df=ng \
  --tag='fermium-chrome-ng-10.1.1' \
  --build-arg=from_tag='fermium-chrome'

## angular 10.2.2
#
./scripts/build-image.sh ${PUSH_AFTER_BUILD} \
  --df=ng \
  --tag=fermium-ng \
  --suffix='10.2.2 latest' \
  --build-arg=angular_cli_version='10.2.2' \
  --build-arg=from_tag='fermium'

./scripts/build-image.sh ${PUSH_AFTER_BUILD} \
  --df=ng \
  --tag=fermium-chrome-ng \
  --suffix='10.2.2 latest' \
  --build-arg=angular_cli_version='10.2.2' \
  --build-arg=from_tag='fermium-chrome'

./scripts/build-image.sh ${PUSH_AFTER_BUILD} \
  --df=ng \
  --tag=fermium-cypress-ng \
  --suffix='10.2.2 latest' \
  --build-arg=angular_cli_version='10.2.2' \
  --build-arg=from_tag='fermium-cypress'

echo $'# node-extra-packages\n' > README.md
echo $'## Docker tags availables\n' >> README.md
all_links >> README.md
