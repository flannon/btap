#!/bin/bash

set -e

INSTALLDIR=/usr/local/bin
SCRIPT=btap.sh

[[ -f $(cd "$(dirname "$0")" && pwd)/${SCRIPT} ]] || { echo "Not found ${SCRIPT}"; exit 3; }

if  [[ $EUID -ne 0 ]]; then
  echo "$0 must be installed as root."
  exit 3
fi

if [[ ! -f $INSTALLDIR ]]; then
  mkdir -p $INSTALLDIR
fi

if [[ ! -f "${INSTALLDIR}/${SCRIPT}" ]]; then
  cp -f ./${SCRIPT} ${INSTALLDIR}/${SCRIPT}
  ln -s ${INSTALLDIR}/${SCRIPT} ${INSTALLDIR}/${SCRIPT::4}
else
  echo "${INSTALLDIR}/${SCRIPT} exists"
fi
