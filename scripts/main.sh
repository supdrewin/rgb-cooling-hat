#!/bin/bash

# main.sh - written by supdrewin
# Wed May 4 21:12:16 CST 2022

cmdline() {
    local path="%{prefix}/lib/rgb-cooling-hat/$1.sh"

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
}

# shellcheck disable=SC1091
. "%{prefix}/lib/rgb-cooling-hat/config.sh"

# shellcheck disable=SC1091,SC2154
. "$rgb_cooling_hat_config_path/config"

set -e

[[ $device ]] || find_device
[[ $thermal ]] || find_thermal

[[ $1 ]] && {
    cmdline "$@"
    exit $?
}

[[ -f "$rgb_cooling_hat_config_path/rgb" ]] && {
    # shellcheck disable=SC1091
    . "$rgb_cooling_hat_config_path/rgb"
}

[[ $fan_speed_a && $fan_speed_b ]] || {
    cmdline fan --func 2 20
}

while :; do
    cmdline fan --set
    sleep 1
done
