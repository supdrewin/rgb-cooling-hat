#!/bin/bash

# oled.sh - written by supdrewin
# Mon Jun 6 13:25:14 CST 2022

# shellcheck disable=SC1091
. "%{prefix}/lib/rgb-cooling-hat/config.sh"

# shellcheck disable=SC1091,SC2154
. "$rgb_cooling_hat_config_path/config"

# shellcheck disable=SC2154
"%{prefix}/lib/rgb-cooling-hat/ssd1306" "$device" "$thermal"
