#!/usr/bin/env bash

. ./scripts/lib.sh
. ./scripts/dock-functions.sh

# base image
./scripts/build-image.sh \
  --from='fermium-slim' \
  --push \
  --tag='fermium'

./scripts/build-image.sh \
  --df=chrome \
  --from='fermium'
  --tag='fermium-chrome' \
  --push \
  --suffix='86 latest' \


./scripts/build-image.sh \
  --df=cypress \
  --from='fermium' \
  --tag='fermium-cypress' \
  --suffix='latest 5.5.0' \
  --push \
  --build-arg=cypress_version='5.5.0'

./scripts/build-image.sh \
  --df=cypress \
  --from='fermium-chrome' \
  --tag='fermium-chrome-cypress' \
  --suffix='latest 5.5.0' \
  --push \
  --build-arg=cypress_version='5.5.0'

## angular 10.1.1
#
./scripts/build-image.sh \
  --df=ng \
  --from='fermium' \
  --tag=fermium-ng-10.1.1 \
  --push \
  --build-arg=angular_cli_version='10.1.1'

./scripts/build-image.sh \
  --df=ng \
  --from='fermium-chrome' \
  --push \
  --tag='fermium-chrome-ng-10.1.1'

## angular 10.2.2
#
./scripts/build-image.sh \
  --df=ng \
  --from='fermium' \
  --tag=fermium-ng \
  --suffix='10.2.2 latest' \
  --push \
  --build-arg=angular_cli_version='10.2.2'

./scripts/build-image.sh \
  --df=ng \
  --from='fermium-chrome' \
  --tag=fermium-chrome-ng \
  --suffix='10.2.2 latest' \
  --build-arg=angular_cli_version='10.2.2'

./scripts/build-image.sh \
  --df=ng \
  --from='fermium-cypress' \
  --tag=fermium-cypress-ng \
  --suffix='10.2.2 latest' \
  --push \
  --build-arg=angular_cli_version='10.2.2'

echo $'# node-extra-packages\n' > README.md
echo $'## Docker tags availables\n' >> README.md
all_links >> README.md
