#!/bin/bash

# i2c-pwm.sh - written by supdrewin
# Wed May  4 21:12:16 CST 2022

i2cw_path=$(which i2cw 2>/dev/null)

[[ $i2cw_path ]] || {
    echo "i2cw not found, maybe you have a broken install?"
    exit 127
}

i2cdetect_path=$(which i2cdetect 2>/dev/null)

[[ $i2cdetect_path ]] || {
    echo "i2cdetect not found, please install it and try again!"
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
    echo "Watch the CPU thermal is unsupported! Abort..."
    exit 132
}

devices=$(find /dev -name "i2c-[0-9]*")

for device in $devices; do
    device=${device##*-}

    if $i2cdetect_path -y "$device" | grep -q 0d; then
        break
    fi

    unset device
done

[[ $device ]] || {
    echo "Required device not found, make sure it's plugged in!"
    exit 1
}

if $i2cdetect_path -y "$device" | grep -q 3c; then
    i2c_oled_path=$(which i2c-oled 2>/dev/null)

    if [[ $i2c_oled_path ]]; then
        $i2c_oled_path "$device" "$temp_path" &
    else
        echo "i2c-oled not found, but ignore it..."
    fi
fi

while :; do
    ((temp = $(cat "$temp_path") / 1000))

    case $temp in
    0[0-9]) speed=0x02 ;;
    1[0-9]) speed=0x03 ;;
    2[0-9]) speed=0x04 ;;
    3[0-4]) speed=0x05 ;;
    3[5-9]) speed=0x06 ;;
    4[0-4]) speed=0x07 ;;
    4[5-9]) speed=0x08 ;;
    5[0-4]) speed=0x09 ;;
    *) speed=0x01 ;;
    esac

    $i2cw_path \
        --device "$device" \
        --address 0x0d \
        --register 0x08 \
        --data byte $speed

    sleep 1
done
