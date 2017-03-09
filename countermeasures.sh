#!/bin/bash

MODE=755

APPLECAMERA=/Library/CoreMediaIO/Plug-Ins/DAL/AppleCamera.plugin/Contents/MacOS/AppleCamera
AVC=/System/Library/PrivateFrameworks/CoreMediaIOServicesPrivate.framework/Versions/A/Resources/AVC.plugin/Contents/MacOS/AVC
CMIOVDC=/System/Library/Frameworks/CoreMediaIO.framework/Versions/A/Resources/VDC.plugin/Contents/MacOS/VDC 
CMIOSVDC=/System/Library/PrivateFrameworks/CoreMediaIOServices.framework/Versions/A/Resources/VDC.plugin/Contents/MacOS/VDC
CMIOSPVDC=/System/Library/PrivateFrameworks/CoreMediaIOServicesPrivate.framework/Versions/A/Resources/VDC.plugin/Contents/MacOS/VDC
QTDIGITIZER=/System/Library/QuickTime/QuickTimeUSBVDCDigitizer.component/Contents/MacOS/QuickTimeUSBVDCDigitizer

function cutcamera() {

  for FILE in $APPLECAMERA $AVC $CMIOVDC $CMIOSVDC $CMIOSPVDC $QTDIGITIZER;
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

  for FILE in $APPLECAMERA $AVC $CMIOVDC $CMIOSVDC $CMIOSPVDC $QTDIGITIZER;
  do
    if [[ -f $FILE ]]; then
      MODEI=$(stat -f %p $FILE)
      if [[ $MODEI == 100755 ]]; then
        chmod 000 $FILE
      fi
    fi
  done

}

function rollcamera() {

  for FILE in $APPLECAMERA $AVC $CMIOVDC $CMIOSVDC $CMIOSPVDC $QTDIGITIZER;
  do
    if [[ -f $FILE ]]; then
      chmod 755 $FILE
    fi
  done

}

function cutsound() {

  ZEROMIC=$(osascript -e 'input volume of (get volume settings)')

  printf "$ZEROMIC\n"

  if [[ $ZEROMIC != 0 ]]; then
    osascript -e 'set volume input volume 0'
  fi

}

function rollsound() {

  osascript -e 'set volume input volume 100'

}

#cutsound
#cutcamera
#disablecamera

#rollcamera
#rollsound
