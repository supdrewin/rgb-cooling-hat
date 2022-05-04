#!/bin/bash

# pwm.sh - written by supdrewin
# Wed May  4 21:12:16 CST 2022

i2cw_path=$(which i2cw 2>/dev/null)

[[ $i2cw_path ]] || {
    echo "i2cw not found, maybe you have a broken install?"
    exit 1
}

zones=$(find /sys/class/thermal -name "thermal_zone[0-9]*")

for zone in $zones; do
    [[ $(cat "$zone/type") = cpu-thermal ]] && {
        temp_path="$zone/temp"
        break
    }
done

list=$(find /dev -name "i2c-[0-9]*")

for i2c in $list; do
    i2c=${i2c##*-}

    if i2cdetect -y "$i2c" | grep -q 0d; then
        break
    fi

    unset i2c
done

[[ $i2c ]] || {
    echo "Required device not found!"
    exit 1
}

while :; do
    ((temp = $(cat "$temp_path") / 1000))

    case $temp in
    [0-1][0-9]) speed=0x02 ;;
    2[0-9]) speed=0x03 ;;
    3[0-4]) speed=0x04 ;;
    3[5-9]) speed=0x05 ;;
    4[0-4]) speed=0x06 ;;
    4[5-9]) speed=0x07 ;;
    5[0-4]) speed=0x08 ;;
    5[5-9]) speed=0x09 ;;
    [6-9][0-9]) speed=0x01 ;;
    *) speed=0x00 ;;
    esac

    $i2cw_path \
        --data-byte $speed \
        --device "$i2c" \
        --address 0d \
        --register 08

    sleep 1
done
