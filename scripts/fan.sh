#!/bin/bash

# fan.sh - written by supdrewin
# Fri Jun 3 15:19:55 CST 2022

help() {
    local self=${0##*/}

    echo "
$self - Utility for fan control

usage:
  $self <speed>  set the fan speed
  $self --help   show this help

options:
  speed  percentage, possibly 0~100
"

    exit
}

[[ $1 = --help ]] && help

"%/lib/rgb-cooling-hat/env.sh"

if (($1 == 0)); then
    speed=0
elif (($1 >= 100)); then
    speed=1
elif (($1 < 20)); then
    speed=2
else
    ((speed = $1 / 10))
fi

# shellcheck disable=SC2154
$rgb_cooling_hat_cmd -r 8 -d b $speed
