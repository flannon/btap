#!/bin/bash

set -e

INSTALLDIR=/usr/local/bin
BASENAME=btap.sh

if  [[ $EUID -ne 0 ]]; then
  echo "$0 must be installed as root."
  exit 3
fi

if [[ ! -f $INSTALLDIR ]]; then
  mkdir -p $INSTALLDIR
fi

if [[ ! -f "${INSTALLDIR}/${BASENAME}" ]]; then
  cp -f ./${BASENAME} ${INSTALLDIR}/${BASENAME}
  ln -s ${INSTALLDIR}/${BASENAME} ${INSTALLDIR}/${BASENAME::4}
else
  echo "${INSTALLDIR}/${BASENAME} exists"
fi
