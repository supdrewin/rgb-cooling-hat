#!/bin/bash

# i2c-rgb.sh - written by supdrewin
# Fri May  6 23:05:04 CST 2022

[[ $i2cw_path ]] || {
    i2cw_path=$(which i2cw 2>/dev/null)
    export i2cw_path
}

[[ $i2c_dev ]] || {
    i2c_devs=$(find /dev -name "i2c-[0-9]*")

    for i2c_dev in $i2c_devs; do
        i2c_dev=${i2c_dev##*-}

        if i2cdetect -y "$i2c_dev" | grep -q 0d; then
            export i2c_dev
            break
        fi
    done
}

[[ $i2c_rgb_cmd ]] || {
    i2c_rgb_cmd="$i2cw_path -d $i2c_dev -a 0x0d"
    export i2c_rgb_cmd
}

--select() {
    --color() {
        local color=${1##0x}

        local r=${color[1, 2]}
        local g=${color[3, 4]}
        local b=${color[5, 6]}

        $i2c_rgb_cmd -r 0x01 -db "$r"
        $i2c_rgb_cmd -r 0x02 -db "$g"
        $i2c_rgb_cmd -r 0x03 -db "$b"
    }

    1() {
        $i2c_rgb_cmd -r 0x00 -db 0x00

        # shellcheck disable=SC2086
        $1 $2
    }

    2() {
        $i2c_rgb_cmd -r 0x00 -db 0x01

        # shellcheck disable=SC2086
        $1 $2
    }

    3() {
        $i2c_rgb_cmd -r 0x00 -db 0x02

        # shellcheck disable=SC2086
        $1 $2
    }

    all() {
        $i2c_rgb_cmd -r 0x00 -db 0xff

        # shellcheck disable=SC2086
        $1 $2
    }

    "$@"
}

--mode() {
    --color() {
        red() {
            $i2c_rgb_cmd -r 0x06 -db 0x00
        }

        green() {
            $i2c_rgb_cmd -r 0x06 -db 0x01
        }

        blue() {
            $i2c_rgb_cmd -r 0x06 -db 0x02
        }

        yellow() {
            $i2c_rgb_cmd -r 0x06 -db 0x03
        }

        purple() {
            $i2c_rgb_cmd -r 0x06 -db 0x04
        }

        cyan() {
            $i2c_rgb_cmd -r 0x06 -db 0x05
        }

        white() {
            $i2c_rgb_cmd -r 0x06 -db 0x06
        }

        "$1"
    }

    water() {
        $i2c_rgb_cmd -r 0x04 -db 0x00

        # shellcheck disable=SC2086
        $1 $2
    }

    breathing() {
        $i2c_rgb_cmd -r 0x04 -db 0x01

        # shellcheck disable=SC2086
        $1 $2
    }

    marquee() {
        $i2c_rgb_cmd -r 0x04 -db 0x02
    }

    rainbow() {
        $i2c_rgb_cmd -r 0x04 -db 0x03
    }

    dazzle() {
        $i2c_rgb_cmd -r 0x04 -db 0x04
    }

    "$@"
}

--speed() {
    low() {
        $i2c_rgb_cmd -r 0x05 -db 0x00
    }

    middle() {
        $i2c_rgb_cmd -r 0x05 -db 0x01
    }

    high() {
        $i2c_rgb_cmd -r 0x05 -db 0x02
    }

    "$1"
}

--close() {
    $i2c_rgb_cmd -r 0x07 -db 0x00
}

"$@"
