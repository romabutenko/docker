#!/bin/sh

INIT_FILES=
FILES=

for f in */docker-entrypoint-initdb.d/; do
  echo "${f}"
  #  FILES="${FILES}./${f} "
done

FILES=${FILES%?}

echo "${FILES}"

export INIT_FILES="${FILES}"


