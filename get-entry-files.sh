#!/bin/sh

ENTRY_FILES=
FILES=

for f in */docker-entrypoint-init.d/*; do
  FILES="${FILES}./${f} "
done

FILES=${FILES%?}

echo "${FILES}"

export ENTRY_FILES="${FILES}"
