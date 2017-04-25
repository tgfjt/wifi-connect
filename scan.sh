#!/usr/bin/env sh

airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

if [ ! -f $airport ]; then
  echo "ERROR: Can't find \`airport\` at \"$airport\"."
  exit 1
fi

PREV_IFS=$IFS
IFS=$'\n'

for network in $(${airport} -s)
do
  IFS=$PREV_IFS

  ssid=`echo $network | cut -d ' ' -f 1`

  if [ $ssid != 'SSID' ]; then
    echo $ssid
  fi
done
