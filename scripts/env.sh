#!/bin/bash

# env.sh - written by supdrewin
# Fri Jun 3 15:15:29 CST 2022

[[ $rgb_cooling_hat_dev ]] || {
    i2c_devs=$(find /dev -name "i2c-[0-9]*")

    for i2c_dev in $i2c_devs; do
        rgb_cooling_hat_dev=${i2c_dev##*-}

        if i2cw -i "$rgb_cooling_hat_dev" -c d; then
            export rgb_cooling_hat_dev && break
        fi

        unset rgb_cooling_hat_dev
    done
}

[[ $rgb_cooling_hat_cmd ]] || {
    rgb_cooling_hat_cmd="i2cw -i $rgb_cooling_hat_dev -a d"
    export rgb_cooling_hat_cmd
}
