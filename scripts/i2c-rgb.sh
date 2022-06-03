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

        if $i2cw_path -i "$i2c_dev" -c d; then
            export i2c_dev
            break
        fi
    done
}

[[ $i2c_rgb_cmd ]] || {
    i2c_rgb_cmd="$i2cw_path -i $i2c_dev -a d"
    export i2c_rgb_cmd
}

--help() {
    local self=${0##*/}

    echo "
$self - Utility for RGB control

usage:
  $self --select 1|2|3|all [--color [0x]ffffff]
  $self --mode mode(see below) [--color color(see below)]
  $self --speed low|middle|high
  $self --close
  $self --help

options:
  mode   water|breathing|marquee|rainbow|dazzle
  color  red|green|blue|yellow|purple|cyan|white
"
}

--select() {
    --color() {
        local color=${1##0x}

        local r=${color:0:2}
        local g=${color:2:2}
        local b=${color:4:2}

        $i2c_rgb_cmd -r 1 -d b "$r"
        $i2c_rgb_cmd -r 2 -d b "$g"
        $i2c_rgb_cmd -r 3 -d b "$b"
    }

    1() {
        $i2c_rgb_cmd -r 0 -d b 0

        # shellcheck disable=SC2086
        $1 $2
    }

    2() {
        $i2c_rgb_cmd -r 0 -d b 1

        # shellcheck disable=SC2086
        $1 $2
    }

    3() {
        $i2c_rgb_cmd -r 0 -d b 2

        # shellcheck disable=SC2086
        $1 $2
    }

    all() {
        $i2c_rgb_cmd -r 0 -d b ff

        # shellcheck disable=SC2086
        $1 $2
    }

    "$@"
}

--mode() {
    --color() {
        red() {
            $i2c_rgb_cmd -r 6 -d b 0
        }

        green() {
            $i2c_rgb_cmd -r 6 -d b 1
        }

        blue() {
            $i2c_rgb_cmd -r 6 -d b 2
        }

        yellow() {
            $i2c_rgb_cmd -r 6 -d b 3
        }

        purple() {
            $i2c_rgb_cmd -r 6 -d b 4
        }

        cyan() {
            $i2c_rgb_cmd -r 6 -d b 5
        }

        white() {
            $i2c_rgb_cmd -r 6 -d b 6
        }

        "$1"
    }

    water() {
        $i2c_rgb_cmd -r 4 -d b 0

        # shellcheck disable=SC2086
        $1 $2
    }

    breathing() {
        $i2c_rgb_cmd -r 4 -d b 1

        # shellcheck disable=SC2086
        $1 $2
    }

    marquee() {
        $i2c_rgb_cmd -r 4 -d b 2
    }

    rainbow() {
        $i2c_rgb_cmd -r 4 -d b 3
    }

    dazzle() {
        $i2c_rgb_cmd -r 4 -d b 4
    }

    "$@"
}

--speed() {
    low() {
        $i2c_rgb_cmd -r 5 -d b 0
    }

    middle() {
        $i2c_rgb_cmd -r 5 -d b 1
    }

    high() {
        $i2c_rgb_cmd -r 5 -d b 2
    }

    "$1"
}

--close() {
    $i2c_rgb_cmd -r 7 -d b 0
}

"$@"
