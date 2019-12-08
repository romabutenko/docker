#!/bin/sh

ENTRYPOINTS=
FILES=
for f in */docker-entrypoint-init.d/*; do
  FILES="${FILES}./$f "
done

ENTRYPOINTS=${FILES%?}
echo "${ENTRYPOINTS}"

export ENTRYPOINTS
