#!/usr/bin/env bash

. ./scripts/lib.sh
. ./scripts/dock-functions.sh

# base image
./scripts/build-image.sh \
  --df=erbium \
  --push

# base image angular
./scripts/build-image.sh \
  --df=ng \
  --tag=erbium-ng \
  --alias='10.1.1' \
  --push \
  --build-arg 'from_tag=erbium'

./scripts/build-image.sh \
  --df=chrome \
  --tag='erbium-chrome' \
  --alias='86 latest' \
  --push \
  --build-arg 'from_tag=erbium'

./scripts/build-image.sh \
  --df=chrome \
  --tag='erbium-ng-chrome' \
  --alias='86 latest' \
  --push \
  --build-arg 'from_tag=erbium-ng'

./scripts/build-image.sh \
  --df=cypress \
  --tag='erbium-cypress' \
  --alias='latest 5.5.0' \
  --push \
  --build-arg 'cypress_version=5.5.0' \
  --build-arg 'from_tag=erbium'

./scripts/build-image.sh \
  --df=cypress \
  --tag='erbium-chrome-cypress' \
  --alias='latest 5.5.0' \
  --push \
  --build-arg 'cypress_version=5.5.0' \
  --build-arg 'from_tag=erbium-chrome'

./scripts/build-image.sh \
  --df=cypress \
  --tag='erbium-ng-cypress' \
  --alias='latest 5.5.0' \
  --push \
  --build-arg 'cypress_version=5.5.0' \
  --build-arg 'from_tag=erbium-ng'

./scripts/build-image.sh \
  --df=cypress \
  --tag='erbium-ng-chrome-cypress' \
  --alias='latest 5.5.0' \
  --push \
  --build-arg 'cypress_version=5.5.0' \
  --build-arg 'from_tag=erbium-ng-chrome'

echo $'# node-extra-packages\n' > README.md
echo $'## Docker tags availables\n' >> README.md
all_links >> README.md
