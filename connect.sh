#!/usr/bin/env sh

nsu="networksetup"

usage() {
  cat <<EOT
Usage: connect <SSID>
EOT
}

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
  case $1 in
    -h | --help )
      usage
      exit
      ;;
  esac
  shift
done
if [[ "$1" == "--" ]]; then shift; fi

ssid=''
if [ -t 0 ] ; then
  ssid=$1
else
  ssid="$(cat -)"
fi

pwd="`security find-generic-password -w -D 'AirPort network password' -ga \"$ssid\"`"
echo $pwd
if [[ $pwd =~ "could" ]]; then
  echo "ERROR: Do you remember the password \"$ssid\"?" >&2
  exit 1
fi

iface=$(${nsu} -listallhardwareports | grep -w Wi-Fi -A1 | awk '/^Device:/{ print $2 }')

$(${nsu} -getairportnetwork ${iface} | grep -wq $ssid)
if [ $? -eq 0 ]; then
  echo 'Connected.'
  exit 0
fi

$(${nsu} -setairportnetwork ${iface} $ssid $pwd | grep -wq 'Error')
if [ ! $? -ne 0 ]; then
  echo "Failed to connect."
fi

$(${nsu} -getairportnetwork ${iface} | grep -wq $ssid)
if [ $? -ne 0 ]; then
  echo 'Something wrong.'
  exit 6
fi

echo 'Connected successfully.'
exit 0
