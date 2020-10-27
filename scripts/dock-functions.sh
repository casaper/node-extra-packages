#!/usr/bin/env bash

export REPO_NAME='casaper/node-extra-packages'
export HUB_REPO_URL="https://hub.docker.com/r/${REPO_NAME}"


function list_images () {
  QUIET='false'
  while test $# -gt 0; do
    case "$1" in
    -q)
      QUIET='true'
      shift
      ;;
    *)
      break
      ;;
    esac
  done
  if [ "$QUIET" = 'true' ]; then
    docker image ls -f 'reference=casaper/node-extra-packages*' -q
  else
    docker image ls -f 'reference=casaper/node-extra-packages*'
  fi
}

function inspect_all_images () {
  docker image inspect $(list_images -q)
}


function inspect_to_json () {
  docker image inspect $@ > docker-images.json
}

function all_tags () {
  AS_MD_LIST='false'
  while test $# -gt 0; do
    case "$1" in
    --ul)
      AS_MD_LIST='true'
      shift
      ;;
    --title=*)
      TITLE="${1//--title=/}"
      shift
      ;;
    *)
      break
      ;;
    esac
  done
  RESULT=$(list_images | cut -d ' ' -f 4 | sort | uniq)
  if [ "$AS_MD_LIST" = 'true' ]; then
    RESULT=$(echo "${RESULT}" | sed 's/^/- /g')
  fi
  if [ -n "$TITLE" ]; then
    RESULT="# ${TITLE}"$'\n\n'"${RESULT}"
  fi
  echo -e "$RESULT"
}

function convert_sha() {
  sed 's/sha256:/sha256-/g' <<< "$1"
}

function all_links() {
  DOK_FORMAT='table {{.Tag}};{{.ID}}'
  MD_LIST=''
  for i in $(docker image ls -f "reference=${REPO_NAME}*" --format "${DOK_FORMAT}" | tail -n +2); do
    TAG=$(cut -d ';' -f 1 <<< "$i")
    ID=$(cut -d ';' -f 2 <<< "$i")
    REPO_DIGESTS=$(docker image inspect "$ID" --format '{{.RepoDigests}}' | cut -d '[' -f 2 | cut -d ']' -f 1)
    REPO_DIGEST=$(echo "$REPO_DIGESTS" | cut -d ' ' -f 1)
    DIGEST_SHA=$(echo "$REPO_DIGEST" | cut -d ':' -f 2)
    IMG_URL="https://hub.docker.com/layers/${REPO_NAME}/${TAG}/images/sha256-${DIGEST_SHA}?context=explore"
    MD_LIST="${MD_LIST}- [${REPO_NAME}:${TAG}](${IMG_URL})"$'\n'
  done
  echo "$MD_LIST"
}
