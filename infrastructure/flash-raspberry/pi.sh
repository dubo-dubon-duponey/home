#!/usr/bin/env bash

# https://hackernoon.com/raspberry-pi-headless-install-462ccabd75d0
mkdir -p cache

core=2019-06-24
version=2019-06-20-raspbian-buster-lite

if [ "$VERSION" == "stretch" ]; then
  core=2019-04-09
  version=2019-04-08-raspbian-stretch-lite
fi

if [ ! -e "./cache/$version.zip" ] || [ "$REFRESH" ]; then
  if ! curl -fsSL -o "./cache/$version.zip" "https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-$core/$version.zip"; then
    rm ./cache/$version.zip
    echo "Download failed"
    exit 1
  fi
  cd cache
  unzip "$version.zip"
  cd -
fi

# diskutil list
helpers::lastExternalDevice(){
  local last
  last="$(diskutil list | grep "external, physical")"
  last="${last##*/dev/disk}"
  printf "%s" "${last%% *}"

}

device=$(helpers::lastExternalDevice)
printf "We think this disk is the one you want: /dev/disk%s - here is the detailed info below\n" "$device"
diskutil info "/dev/disk$device"
printf "We are about to overwrite it. If this is NOT correct, CTRL+C NOW. Otherwise, enter to continue.\n"
read

diskutil unmountDisk "/dev/disk$device"
sudo dd bs=1m if=./cache/$version.img of=/dev/disk"$device" conv=sync

touch /Volumes/boot/ssh
diskutil unmountDisk "/dev/disk$device"

printf "Done. You may now eject the device card and boot the pi."
