#!/bin/sh

INIT_FILES=
FILES=

for f in */docker-entrypoint-init.d/*; do
  FILES="${FILES}./${f} "
done

FILES=${FILES%?}

echo "${FILES}"

export INIT_FILES="${FILES}"
