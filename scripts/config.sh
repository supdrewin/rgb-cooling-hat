#!/bin/bash

# config.sh - written by supdrewin
# Mon Jun 6 11:18:44 CST 2022

rgb_cooling_hat_config_path=/etc/rgb-cooling-hat

write_config() {
    [[ $1 && $2 ]] && {
        sed -i "/$1/d" $rgb_cooling_hat_config_path/config
        echo "$1=$2" >>$rgb_cooling_hat_config_path/config

        touch $rgb_cooling_hat_config_path/changed
    }
}

find_device() {
    # shellcheck disable=SC2155
    local i2c_devs=$(find /dev -name "i2c-[0-9]*")

    for i2c_dev in $i2c_devs; do
        i2c_dev=${i2c_dev##*-}

        if i2cw -i "$i2c_dev" -c d; then
            write_config device "$i2c_dev"
            break
        fi
    done
}

find_thermal() {
    # shellcheck disable=SC2155
    local zones=$(find /sys/class/thermal -name "thermal_zone[0-9]*")

    for zone in $zones; do
        [[ $(cat "$zone/type") = cpu-thermal ]] && {
            write_config thermal "$zone/temp"
            break
        }
    done
}
