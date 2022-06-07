#!/bin/bash

# fan.sh - written by supdrewin
# Fri Jun 3 15:19:55 CST 2022

--help() {
    local self=${0##*/}

    echo "
$self - Utility for fan control

usage:
  $self [--func a b] [--set]
  $self --speed speed
  $self --help

options:
  --func a b     set fan speed according to current temp
                 fan_speed = temp * a + b
  --set          use fan speed function immediately
  --speed speed  set fan speed in percentage (0..=100)
  --help         show this help
"

    exit
}

--func() {
    [[ $2 && $3 ]] || return 1

    write_config fan_speed_a "$2"
    write_config fan_speed_b "$3"

    [[ $4 = --set ]] && {
        # shellcheck disable=SC1091,SC2154
        . "$rgb_cooling_hat_config_path/config"

        "--set"
    }
}

# shellcheck disable=SC2154
--set() {
    local fan_speed temp

    temp=$(cat "$thermal" || echo 0)

    ((fan_speed = "$temp" * "$fan_speed_a" / 1000 + "$fan_speed_b"))
    "--speed" $fan_speed
}

--speed() {
    local speed

    if (($1 <= 0)); then
        speed=0
    elif (($1 >= 100)); then
        speed=1
    elif (($1 < 20)); then
        speed=2
    else
        ((speed = $1 / 10))
    fi

    # shellcheck disable=SC2154
    i2cw -i "$device" -a d -r 8 -d b $speed
}

# shellcheck disable=SC1091
. "%{prefix}/lib/rgb-cooling-hat/config.sh"

# shellcheck disable=SC1091,SC2154
. "$rgb_cooling_hat_config_path/config"

"$@"
