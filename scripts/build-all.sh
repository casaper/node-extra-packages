#!/usr/bin/env bash

. ./scripts/lib.sh
. ./scripts/dock-functions.sh

while test $# -gt 0; do
  case "$1" in
  --push)
    PUSH_AFTER_BUILD=" --push "
    shift
    ;;
  *)
    break
    ;;
  esac
done


# base image
./scripts/build-image.sh \
  --from='fermium-slim' \
  --tag='fermium' ${PUSH_AFTER_BUILD}

./scripts/build-image.sh \
  --df=chrome \
  --from='fermium'
  --tag='fermium-chrome' \
  --suffix='86 latest' ${PUSH_AFTER_BUILD}


./scripts/build-image.sh \
  --df=cypress \
  --from='fermium' \
  --tag='fermium-cypress' \
  --suffix='latest 5.5.0' \
  --build-arg=cypress_version='5.5.0' ${PUSH_AFTER_BUILD}

./scripts/build-image.sh \
  --df=cypress \
  --from='fermium-chrome' \
  --tag='fermium-chrome-cypress' \
  --suffix='latest 5.5.0' \
  --build-arg=cypress_version='5.5.0' ${PUSH_AFTER_BUILD}

## angular 10.1.1
#
./scripts/build-image.sh \
  --df=ng \
  --from='fermium' \
  --tag=fermium-ng-10.1.1 \
  --build-arg=angular_cli_version='10.1.1' ${PUSH_AFTER_BUILD}

./scripts/build-image.sh \
  --df=ng \
  --from='fermium-chrome' \
  --tag='fermium-chrome-ng-10.1.1' ${PUSH_AFTER_BUILD}

## angular 10.2.2
#
./scripts/build-image.sh \
  --df=ng \
  --from='fermium' \
  --tag=fermium-ng \
  --suffix='10.2.2 latest' \
  --build-arg=angular_cli_version='10.2.2' ${PUSH_AFTER_BUILD}

./scripts/build-image.sh \
  --df=ng \
  --from='fermium-chrome' \
  --tag=fermium-chrome-ng \
  --suffix='10.2.2 latest' \
  --build-arg=angular_cli_version='10.2.2' ${PUSH_AFTER_BUILD}

./scripts/build-image.sh \
  --df=ng \
  --from='fermium-cypress' \
  --tag=fermium-cypress-ng \
  --suffix='10.2.2 latest' \
  --build-arg=angular_cli_version='10.2.2' ${PUSH_AFTER_BUILD}

echo $'# node-extra-packages\n' > README.md
echo $'## Docker tags availables\n' >> README.md
all_links >> README.md
