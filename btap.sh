#!/bin/bash

#set -euvx
#set -eu

#if [[ $EUID -ne 0 ]]; then
#  echo "$0 must be run as root."
#  exit 1
#fi

verbose='false'
logfile='/usr/local/var/log'


readonly BTAP_FULL_PATH="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
readonly INSTALLDIR="/usr/local/bin"
readonly CUTMODE=100000
readonly ROLLINGMODE=755
readonly LAUNCHDIR="/Library/LaunchDaemons"
readonly PLIST="com.5eight5.btap.plist"

readonly APPLECAMERA=/Library/CoreMediaIO/Plug-Ins/DAL/AppleCamera.plugin/Contents/MacOS/AppleCamera
readonly AVC=/System/Library/PrivateFrameworks/CoreMediaIOServicesPrivate.framework/Versions/A/Resources/AVC.plugin/Contents/MacOS/AVC
readonly CMIOVDC=/System/Library/Frameworks/CoreMediaIO.framework/Versions/A/Resources/VDC.plugin/Contents/MacOS/VDC
readonly CMIOSVDC=/System/Library/PrivateFrameworks/CoreMediaIOServices.framework/Versions/A/Resources/VDC.plugin/Contents/MacOS/VDC
readonly CMIOSPVDC=/System/Library/PrivateFrameworks/CoreMediaIOServicesPrivate.framework/Versions/A/Resources/VDC.plugin/Contents/MacOS/VDC
readonly QTDIGITIZER=/System/Library/QuickTime/QuickTimeUSBVDCDigitizer.component/Contents/MacOS/QuickTimeUSBVDCDigitizer

readonly OSVERSION=$(sw_vers -productVersion)

# Set $VDC based on OS major version
case ${OSVERSION::5} in
  10.9.)
    [[ -f $CMIOVDC ]] || { echo "OS ${OSVERSION}: VDC not found"; exit 3; }
    readonly VDC=$CMIOVDC
    ;;
  10.10)
    [[ -f $CMIOSVDC ]] || { echo "OS ${OSVERSION}: VDC not found"; exit 3; }
    readonly VDC=$CMIOSVDC
    ;;
  10.11)
    [[ -f $CMIOVDC ]] || { echo "OS ${OSVERSION}: VDC not found"; exit 3; }
    readonly VDC=$CMIOVDC
    ;;
  *)
    echo "OS ${OSVERSION} not supported at this time" && exit 4;
    ;;
esac

declare -a readonly FILES=($APPLECAMERA $AVC $VDC $QTDIGITIZER)

launcher() {

  echo "Load lauch config ${PLIST}"

  cat << EOF > ${LAUNCHDIR}/${PLIST}
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${PLIST}</string>
    <key>ProgramArguments</key>
    <array>
    <string>${BTAP_FULL_PATH}</string>
        <string>-f</string>
    </array>
    <key>StartInterval</key>
    <integer>5</integer>
</dict>
</plist>
EOF

launchctl load -w ${LAUNCHDIR}/${PLIST}

}

cutcamera() {

  local file
  local pid
  local pids

  echo "Cut video..."

  for file in "${FILES[@]}"
  do
    if [[ -f $file ]]; then
      pids=$( (lsof -Fp $file) )
      for pid in $pids
      do
        if [[ -n $pid ]]; then
          kill -9 ${pid:1}
        fi
      done
    fi
  done

}

disablecamera() {

  local file
  local mode

  echo "Disable video..."

  for file in "${FILES[@]}"
  do
    if [[ -f $file ]]; then
      #echo "file exists: $file"
      #echo $file
      mode=$(stat -f %p $file)
      if [[ $mode != $CUTMODE ]]; then
        chmod $CUTMODE $file
      fi
    fi
  done

}

cutsound() {

  local miclevel=$(osascript -e 'input volume of (get volume settings)')

  echo "Cut sound..."

  if [[ $miclevel != 0 ]]; then
    osascript -e 'set volume input volume 0'
  fi

}

cut() {

  cutsound
  if [[ $EUID -eq 0 ]]; then
    disablecamera
  fi
  cutcamera
  if [[ $EUID -eq 0 ]]; then
    launcher
  fi
  
}

rollcamera() {

  if [[ $EUID -ne 0 ]]; then
    echo "$0 must be run as root to enable camera function."
    exit 1
  fi

  echo "Rolling camera..." 
  local file

  for file in "${FILES[@]}"
  do
    if [[ -f $file ]]; then
      chmod $ROLLINGMODE $file
    fi
  done

}

rollsound() {

  echo "Rolling sound..."
  osascript -e 'set volume input volume 100'

}

action() {

  set -e 

  rollsound
  rollcamera

  if [[ $EUID -eq 0 ]]; then
    launchctl unload -w ${LAUNCHDIR}/${PLIST}
    rm -f ${LAUCHDIR}/${PLIST}
  fi

}

fixer() {
  
  local mode

  # Monitor the camera drivers to make sure 
  # they haven't been re-enabled.  If they have
  # re-run cut().
  for file in "${FILES[@]}"
  do
    mode=$(stat -f %p $file)
    if [[ $mode != '100000' ]]; then
      cut
    fi
  done
  cutsound

}


while getopts 'afil:v' flag;
do
  case "${flag}" in
    a) 
      action
      ;;
    f) 
      fixer
      ;;
    l) logfile="${OPTARG}" ;;
    v) 
      set -x
      cut
      ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

main() {

  #test
  cut
  #disablecamera
  #cutcamera

}

# run main() if no command line arguments
if [[ $# -eq 0 ]]; then
  main "$@"
fi
