#!/usr/bin/env bash

./build-image.sh --df=erbium --push
./build-image.sh --df=ng --tag=erbium-ng --alias='10.1.1' --push
./build-image.sh --df=chrome --tag=erbium-ng-chrome --alias='86 latest' --push
./build-image.sh --df=cypress --tag='erbium-ng-chrome-cypress' --alias='latest 5.4.0' --push