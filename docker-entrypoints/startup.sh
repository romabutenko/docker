#!/bin/sh
if [ "${PWD}" = "/docker-entrypoints" ]
  then
    for f in "${PWD}"/*
do
  if [ "${f}" != "startup.sh" ]
  then
    echo "${f}"
#    /bin/sh "${f}"
  fi
done
fi
