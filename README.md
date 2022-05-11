# RGB Cooling HAT

This repository aims to control the RGB fan of
`YB-EPV02` via I2C protocol.

### Features

- Auto changes the fan speed according to current tempearture.
- Fully control the RGB LEDs via `i2c-rgb` command.
- Provides I2C write feature via `i2cw` command.
- Show current `Freq` and `Temp` if OLED display available.

### Pre-required

Hardware:
- `YB-EPV02` and compatable board
  (e.g. RasPi, RockPi...)
- Make sure the GPIO port has I2C enabled
  (maybe modify the overlay config)

Language:
- Bash - Install bash
- C++  - Install gcc or clang
- Rust - Install via rustup

### Install

Install all files:

``` shell
$ make install
```

Optional enable the pwm service:

``` shell
$ systemctl enable --now i2c-pwm
```

### Uninstall

If you enable the pwm service previous,
firstly disable it:

``` shell
$ systemctl disable --now i2c-pwm
```

Uninstall all files:

``` shell
$ make uninstall
```

### Warning

This repository is unofficial and working myself,
all code of this repository are under `MPL-2.0`,
so any modifies should be open source.
