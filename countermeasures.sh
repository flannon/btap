#!/bin/bash

OSVERSION=$(sw_vers -productVersion)

ROLLINGMODE=755
CUTMODE=000

APPLECAMERA=/Library/CoreMediaIO/Plug-Ins/DAL/AppleCamera.plugin/Contents/MacOS/AppleCamera
AVC=/System/Library/PrivateFrameworks/CoreMediaIOServicesPrivate.framework/Versions/A/Resources/AVC.plugin/Contents/MacOS/AVC
# VDCMAVERICKS
CMIOVDC=/System/Library/Frameworks/CoreMediaIO.framework/Versions/A/Resources/VDC.plugin/Contents/MacOS/VDC 
CMIOSVDC=/System/Library/PrivateFrameworks/CoreMediaIOServices.framework/Versions/A/Resources/VDC.plugin/Contents/MacOS/VDC
CMIOSPVDC=/System/Library/PrivateFrameworks/CoreMediaIOServicesPrivate.framework/Versions/A/Resources/VDC.plugin/Contents/MacOS/VDC
QTDIGITIZER=/System/Library/QuickTime/QuickTimeUSBVDCDigitizer.component/Contents/MacOS/QuickTimeUSBVDCDigitizer

declare -a FILES=($APPLECAMERA $AVC $CMIOVDC $CMIOSVDC $CMIOSPVDC $QTDIGITIZER)

function cutcamera() {

  #for FILE in $APPLECAMERA $AVC $CMIOVDC $CMIOSVDC $CMIOSPVDC $QTDIGITIZER;
  for FILE in "${FILES[@]}"
  do
    if [[ -f $FILE ]]; then
      PID=$(lsof -Fp $FILE)
      #if [[ -z ${PID+x} ]]; then
      if [[ -n $PID ]]; then
        printf "${PID:1}\n"
        kill -9 ${PID:1}
      fi
    fi
  done

}

function disablecamera() {

  #for FILE in $APPLECAMERA $AVC $CMIOVDC $CMIOSVDC $CMIOSPVDC $QTDIGITIZER;
  for FILE in "${FILES[@]}"
  do
    if [[ -f $FILE ]]; then
      MODE=$(stat -f %p $FILE)
      if [[ $MODE == 100755 ]]; then
        chmod $CUTMODE $FILE
      fi
    fi
  done

}

function rollcamera() {

  #for FILE in $APPLECAMERA $AVC $CMIOVDC $CMIOSVDC $CMIOSPVDC $QTDIGITIZER;
  for FILE in "${FILES[@]}"
  do
    if [[ -f $FILE ]]; then
      chmod $ROLLINGMODE $FILE
    fi
  done

}

function cutsound() {

  MICLEVEL=$(osascript -e 'input volume of (get volume settings)')

  printf "$MICLEVEL\n"

  if [[ $MICLEVEL != 0 ]]; then
    osascript -e 'set volume input volume 0'
  fi

}

function rollsound() {

  osascript -e 'set volume input volume 100'

}

function test() {

  for FILE in "${FILES[@]}"
  do
    echo $FILE
  done
}

test

#cutsound
#cutcamera
#disablecamera

#rollcamera
#rollsound
