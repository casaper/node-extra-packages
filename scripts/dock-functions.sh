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

function img_link() {
  REFERENCE="${1}"
  TAG_ID=$(docker image ls ${REFERENCE} --format "table {{.Tag}};{{.ID}}" | tail -n +2)
  TAG=$(cut -d ';' -f 1 <<< "$TAG_ID")
  ID=$(cut -d ';' -f 2 <<< "$TAG_ID")
  REPO_DIGESTS=$(docker image inspect "$ID" --format '{{.RepoDigests}}' | cut -d '[' -f 2 | cut -d ']' -f 1)
  REPO_DIGEST=$(echo "$REPO_DIGESTS" | cut -d ' ' -f 1)
  DIGEST_SHA=$(echo "$REPO_DIGEST" | cut -d ':' -f 2)
  IMG_URL="https://hub.docker.com/layers/${REPO_NAME}/${TAG}/images/sha256-${DIGEST_SHA}?context=explore"
  echo "- [${REPO_NAME}:${TAG}](${IMG_URL})"
}

function add_readme_link_and_csv_row() {
  REFERENCE="${1}"
  TAG_ID=$(docker image ls ${REFERENCE} --format "table {{.Tag}};{{.ID}}" | tail -n +2)
  TAG=$(cut -d ';' -f 1 <<< "$TAG_ID")
  ID=$(cut -d ';' -f 2 <<< "$TAG_ID")
  REPO_DIGESTS=$(docker image inspect "$ID" --format '{{.RepoDigests}}' | cut -d '[' -f 2 | cut -d ']' -f 1)
  REPO_DIGEST=$(echo "$REPO_DIGESTS" | cut -d ' ' -f 1)
  DIGEST_SHA=$(echo "$REPO_DIGEST" | cut -d ':' -f 2)
  IMG_URL="https://hub.docker.com/layers/${REPO_NAME}/${TAG}/images/sha256-${DIGEST_SHA}?context=explore"
  if grep "${TAG}," image_data.csv &>/dev/null; then
    cat image_data.csv | grep --invert-match "${TAG}," > image_data.csv
  fi
  if ! grep "$IMG_URL" image_data.csv &>/dev/null; then
    echo "${TAG},${DIGEST_SHA},${IMG_URL}" >> image_data.csv
  fi
  if grep "\[${REPO_NAME}:${TAG}\]" README.md &>/dev/null; then
    cat README.md | grep --invert-match "\[${REPO_NAME}:${TAG}\]" > README.md
  fi
  if ! grep "$IMG_URL" README.md &>/dev/null; then
    echo "- [${REPO_NAME}:${TAG}](${IMG_URL})" >> README.md
  fi
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
