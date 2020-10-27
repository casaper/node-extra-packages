#!/usr/bin/env bash

. ./scripts/lib.sh

while test $# -gt 0; do
  case "$1" in
  --tag=*)
    TAG="${1//--tag=/}"
    shift
    ;;
  --alias=*)
    ALIASES="${1//--alias=/}"
    shift
    ;;
  --docker_f=*)
    DOCKER_F="${1//--docker_f=/}"
    shift
    ;;
  --df=*)
    DOCKER_F="${1//--df=/}"
    shift
    ;;
  --from=*)
    FROM_TAG="${1//--from=/}"
    shift
    ;;
  --push)
    PUSH_AFTER_BUILD="true"
    shift
    ;;
  *)
    break
    ;;
  esac
done
TAG="${TAG:-"${DOCKER_F}"}"

DOCKER_FILE="Dockerfile"
if [ -n "$DOCKER_F" ]; then
  DOCKER_FILE="${DOCKER_FILE}.${DOCKER_F}"
fi


IMAGE_TAG="casaper/node-extra-packages:${TAG}"

ALIAS_TAGS=""
if [ -n "$ALIASES" ]; then
  for alias_tag in $(echo "$ALIASES" | tr ' ' "\n" | tr ';' "\n"); do
    ALIAS_TAGS="${ALIAS_TAGS}${IMAGE_TAG}-${alias_tag}"$'\n'
  done
fi

echo "DOCKER_FILE: ${DOCKER_FILE}"
echo "FROM_TAG: ${FROM_TAG}"df
echo "TAG: ${TAG}"
echo "IMAGE_TAG: ${IMAGE_TAG}"
echo "ALIAS_TAGS: ${ALIAS_TAGS}"

if [ -n "$FROM_TAG" ]; then
  BUILD_ARG_FROM_TAG=" --build-arg 'from_tag=${FROM_TAG}' "
fi

echo $BUILD_ARG_FROM_TAG

docker build -f "${DOCKER_FILE}"${BUILD_ARG_FROM_TAG} -t "${IMAGE_TAG}" $@ .

for alias_tag in ${ALIAS_TAGS}; do
  docker tag "${IMAGE_TAG}" "${alias_tag}"
done

if [ "$PUSH_AFTER_BUILD" = 'true' ]; then
  docker push "$IMAGE_TAG"

  for alias_tag in ${ALIAS_TAGS}; do
    docker push "${alias_tag}"
  done
fi
