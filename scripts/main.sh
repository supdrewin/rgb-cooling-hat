#!/bin/bash

# main.sh - written by supdrewin
# Wed May 4 21:12:16 CST 2022

[[ $1 ]] && {
    path="%{prefix}/lib/rgb-cooling-hat/$1.sh"

    fan() {
        $path "$@"
    }

    rgb() {
        $path "$@"
    }

    help() {
        local self=${0##*/}

        echo "
$self - RGB Cooling HAT advanced utility

usage:
  $self fan [options...]  fan control command
  $self rgb [options...]  rgb control command
  $self help              show this help

options:
  --help  show help for sub-command
"
    }

    "$@"

    exit $?
}

zones=$(find /sys/class/thermal -name "thermal_zone[0-9]*")

for zone in $zones; do
    [[ $(cat "$zone/type") = cpu-thermal ]] && {
        temp_path="$zone/temp"
        break
    }
done

[[ $temp_path ]] || {
    echo "ERROR: CPU thermal unsupported"
    exit 132
}

devices=$(find /dev -name "i2c-[0-9]*")

for device in $devices; do
    id=${device##*-}

    if i2cw -i "$id" -c 3c; then
        break
    fi

    unset id
done

[[ $id ]] && {
    "%{prefix}/lib/rgb-cooling-hat/ssd1306" "$id" "$temp_path" &
}

while :; do
    ((speed = $(cat "$temp_path") / 500)) && {
        "%{prefix}/lib/rgb-cooling-hat/fan.sh" $speed
        sleep 1
    }
done
