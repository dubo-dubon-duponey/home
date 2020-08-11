#!/usr/bin/env bash

# Use -----> https://github.com/RPi-Distro/pi-gen <---- instead to create our own image

# https://hackernoon.com/raspberry-pi-headless-install-462ccabd75d0
mkdir -p cache

core=2020-02-14
version=2020-02-13-raspbian-buster-lite
# XXX start adding sha checks
# 12ae6e17bf95b6ba83beca61e7394e7411b45eba7e6a520f434b0748ea7370e8

if [ ! -e "./cache/$version.zip" ] || [ "$REFRESH" ]; then
  if ! curl -fsSL -o "./cache/$version.zip" "https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-$core/$version.zip"; then
    rm ./cache/$version.zip
    echo "Download failed"
    exit 1
  fi
  cd cache || exit
  unzip "$version.zip"
  cd - || exit
fi

# diskutil list
helpers::lastExternalDevice(){
  local last
  last="$(diskutil list | grep "external, physical")"
  last="${last##*/dev/disk}"
  printf "%s" "${last%% *}"

}

device=$(helpers::lastExternalDevice)
printf    "We think this disk is the one you want: /dev/disk%s - here is the detailed info below\n" "$device"
diskutil  info "/dev/disk$device"

printf    "We are about to overwrite it. If this is NOT correct, CTRL+C NOW. Otherwise, enter to continue.\n"
read -r

diskutil  unmountDisk "/dev/disk$device"
sudo      dd bs=1m if=./cache/$version.img of=/dev/disk"$device" conv=sync

printf    "Done flashing. Will unmount. \n"
sleep 5
diskutil  unmountDisk "/dev/disk$device" || true
sleep 5
printf    "Will mount, enable ssh, unmount. \n"
diskutil  mountDisk "/dev/disk$device"
touch     /Volumes/boot/ssh
diskutil  unmountDisk "/dev/disk$device"
printf    "Done. You may now boot the pi from the newly flashed card."
