#!/bin/bash

# i2c-fan.sh - written by supdrewin
# Wed May  4 21:12:16 CST 2022

i2cw_path=$(which i2cw 2>/dev/null)

[[ $i2cw_path ]] || {
    echo "ERROR: i2cw not found, installation broken"
    exit 127
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

    if $i2cw_path -i "$id" -c d; then
        break
    fi

    unset id
done

[[ $id ]] || {
    echo "ERROR: required device not found"
    exit 1
}

if $i2cw_path -i "$id" -c 3c; then
    i2c_oled_path=$(which i2c-oled 2>/dev/null)

    if [[ $i2c_oled_path ]]; then
        $i2c_oled_path "$device" "$temp_path" &
    else
        echo "WARNING: i2c-oled not found, installation broken"
    fi
else
    echo "INFORMATION: SSD1306 not found, ignoring it"
fi

while :; do
    case $(($(cat "$temp_path") / 1000)) in
    0[0-9]) speed=2 ;;
    1[0-9]) speed=3 ;;
    2[0-9]) speed=4 ;;
    3[0-4]) speed=5 ;;
    3[5-9]) speed=6 ;;
    4[0-4]) speed=7 ;;
    4[5-9]) speed=8 ;;
    5[0-4]) speed=9 ;;
    *) speed=1 ;;
    esac

    $i2cw_path -i "$id" -a d -r 8 -d b $speed && {
        echo "INFORMATION: adjust fan speed successfully"
        sleep 1
    }
done
