#!/bin/bash

# main.sh - written by supdrewin
# Wed May 4 21:12:16 CST 2022

cmdline() {
    local path="%{prefix}/lib/rgb-cooling-hat/$1.sh"

    fan() {
        $path "$@"

        [[ $1 =~ ^[0-9]{1,3}$ ]] && {
            write_config fan_speed "$1"
        }
    }

    rgb() {
        $path "$@"
    }

    oled() {
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
}

# shellcheck disable=SC1091
. "%{prefix}/lib/rgb-cooling-hat/config.sh"

# shellcheck disable=SC1091,SC2154
. "$rgb_cooling_hat_config_path/config"

[[ $device ]] || find_device

[[ $1 ]] && {
    cmdline "$@"
    exit $?
}

[[ $thermal ]] || find_thermal

cmdline oled &

[[ $fan_speed ]] || cmdline fan --auto

# shellcheck disable=SC2154
while :; do
    # shellcheck disable=SC1091
    [[ -f "$rgb_cooling_hat_config_path/changed" ]] && {
        rm -f "$rgb_cooling_hat_config_path/changed"
        . "$rgb_cooling_hat_config_path/config"
    }

    if [[ $fan_speed = auto ]]; then
        ((speed = $(cat "$thermal") / 500))
    else
        speed=$fan_speed
    fi

    "%{prefix}/lib/rgb-cooling-hat/fan.sh" "$speed"
    sleep 1
done
