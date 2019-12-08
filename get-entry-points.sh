#!/bin/sh
# shellcheck disable=SC2046
export $(xargs < "${PWD}"/.env) > /dev/null 2>&1

ENTRY_POINTS=
POINTS=

for p in */docker-entrypoint-init.d/*; do
  POINTS="${POINTS} $(echo "${p}" | awk -F '/' -v entrypath="${ENTRY_PATH}" '{print entrypath $3}')"
done

rm -f out.txt

echo "${POINTS}"

export ENTRY_POINTS="${POINTS}"
