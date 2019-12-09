#!/bin/sh
# shellcheck disable=SC2046
export $(xargs < "${PWD}"/.env) > /dev/null 2>&1

INIT_POINTS=
POINTS=

for p in */docker-entrypoint-init.d/*; do
  POINTS="${POINTS} $(echo "${p}" | awk -F '/' -v entrypath="${INIT_PATH}" '{print entrypath $3}')"
done

echo "${POINTS}"

export INIT_POINTS="${POINTS}"
