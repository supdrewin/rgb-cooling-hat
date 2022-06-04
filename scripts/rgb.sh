#!/bin/bash

# rgb.sh - written by supdrewin
# Fri May 6 23:05:04 CST 2022

# shellcheck disable=SC2154
"%/lib/rgb-cooling-hat/env.sh"

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

        $rgb_cooling_hat_cmd -r 1 -d b "$r"
        $rgb_cooling_hat_cmd -r 2 -d b "$g"
        $rgb_cooling_hat_cmd -r 3 -d b "$b"
    }

    1() {
        $rgb_cooling_hat_cmd -r 0 -d b 0

        # shellcheck disable=SC2086
        $1 $2
    }

    2() {
        $rgb_cooling_hat_cmd -r 0 -d b 1

        # shellcheck disable=SC2086
        $1 $2
    }

    3() {
        $rgb_cooling_hat_cmd -r 0 -d b 2

        # shellcheck disable=SC2086
        $1 $2
    }

    all() {
        $rgb_cooling_hat_cmd -r 0 -d b ff

        # shellcheck disable=SC2086
        $1 $2
    }

    "$@"
}

--mode() {
    --color() {
        red() {
            $rgb_cooling_hat_cmd -r 6 -d b 0
        }

        green() {
            $rgb_cooling_hat_cmd -r 6 -d b 1
        }

        blue() {
            $rgb_cooling_hat_cmd -r 6 -d b 2
        }

        yellow() {
            $rgb_cooling_hat_cmd -r 6 -d b 3
        }

        purple() {
            $rgb_cooling_hat_cmd -r 6 -d b 4
        }

        cyan() {
            $rgb_cooling_hat_cmd -r 6 -d b 5
        }

        white() {
            $rgb_cooling_hat_cmd -r 6 -d b 6
        }

        "$1"
    }

    water() {
        $rgb_cooling_hat_cmd -r 4 -d b 0

        # shellcheck disable=SC2086
        $1 $2
    }

    breathing() {
        $rgb_cooling_hat_cmd -r 4 -d b 1

        # shellcheck disable=SC2086
        $1 $2
    }

    marquee() {
        $rgb_cooling_hat_cmd -r 4 -d b 2
    }

    rainbow() {
        $rgb_cooling_hat_cmd -r 4 -d b 3
    }

    dazzle() {
        $rgb_cooling_hat_cmd -r 4 -d b 4
    }

    "$@"
}

--speed() {
    low() {
        $rgb_cooling_hat_cmd -r 5 -d b 0
    }

    middle() {
        $rgb_cooling_hat_cmd -r 5 -d b 1
    }

    high() {
        $rgb_cooling_hat_cmd -r 5 -d b 2
    }

    "$1"
}

--close() {
    $rgb_cooling_hat_cmd -r 7 -d b 0
}

"$@"
