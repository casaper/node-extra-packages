#!/usr/bin/env bash

. ./scripts/lib.sh
. ./scripts/dock-functions.sh


while test $# -gt 0; do
  case "$1" in
  --tag=*)
    TAG="${1//--tag=/}"
    shift
    ;;
  --suffix=*)
    ALIAS_SUFIXES="${1//--suffix=/}"
    shift
    ;;
  --fulltags=*)
    FULL_ALIASES="${1//--fulltags=/}"
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
  --push)
    PUSH_AFTER_BUILD="true"
    shift
    ;;
  --readme)
    APPEND_README="true"
    shift
    ;;
  *)
    break
    ;;
  esac
done


# TAG="${TAG:-"${DOCKER_F}"}"

DOCKER_FILE="Dockerfile"
if [ -n "$DOCKER_F" ]; then
  DOCKER_FILE="${DOCKER_FILE}.${DOCKER_F}"
fi

REPO_NAME="casaper/node-extra-packages"
MAIN_TAG="${REPO_NAME}:${TAG}"

echo $'\nparameters:'
echo "TAG: ${TAG}"
echo "MAIN_TAG: ${MAIN_TAG}"
echo "ALIAS_SUFIXES: ${ALIAS_SUFIXES}"
echo "FULL_ALIASES: ${FULL_ALIASES}"
echo "DOCKER_F: ${DOCKER_F}"
echo "DOCKER_F: ${DOCKER_F}"
echo "FROM_TAG: ${FROM_TAG}"
echo "PUSH_AFTER_BUILD: ${PUSH_AFTER_BUILD}"
echo "APPEND_README: ${APPEND_README}"$'\n\n'


# echo "docker build -f \"${DOCKER_FILE}\"${BUILD_ARG_FROM_TAG} -t \"${MAIN_TAG}\" $@ ."
docker build -f "${DOCKER_FILE}" -t "${MAIN_TAG}" $@ .
PRODUCED_TAGS="${MAIN_TAG}"

function make_alias_tag() {
  FROM="${1}"
  TO="${2}"
  PRODUCED_LIST="${3}"$'\n'
  docker tag "${FROM}" "${TO}"
  echo "${PRODUCED_LIST}${TO}"
}

if [ -n "$ALIAS_SUFIXES" ]; then
  for alias_tag in $(echo "$ALIAS_SUFIXES" | tr ' ' "\n" | tr ';' "\n"); do
    PRODUCED_TAGS=$(make_alias_tag "${MAIN_TAG}" "${MAIN_TAG}-${alias_tag}" "${PRODUCED_TAGS}")
  done
fi
if [ -n "$FULL_ALIASES" ]; then
  for alias_tag in $(echo "$FULL_ALIASES" | tr ' ' "\n" | tr ';' "\n"); do
    PRODUCED_TAGS=$(make_alias_tag "${MAIN_TAG}" "${REPO_NAME}:${alias_tag}" "${PRODUCED_TAGS}")
  done
fi

if [ "$APPEND_README" = 'true' ]; then
  echo $'\n\n\n' >> README.md
fi

for alias_tag in ${PRODUCED_TAGS}; do
  if [ "$PUSH_AFTER_BUILD" = 'true' ]; then
    echo $'\n===============\n'"Pushing ${alias_tag} to DockerHub"$'\n===============\n'
    docker push "${alias_tag}"
  fi
  if [ "$APPEND_README" = 'true' ]; then
    add_readme_link_and_csv_row "${alias_tag}"
    # img_link "${alias_tag}" >> README.md
  fi
done

echo $'\n\n===============\n'"Built these docker tags:"$'\n'"${PRODUCED_TAGS}"$'\n===============\n'
