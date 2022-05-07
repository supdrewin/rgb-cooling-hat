# RGB Cooling HAT

This repository aims to control the RGB fan of
`YB-EPV02` via I2C protocol.

### Pre-required

Hardware:
`YB-EPV02` and compatable board
(e.g. RasPi, RockPi...)

Language:
- Bash  Install bash
- C++   Install gcc or clang
- Rust  Install via rustup

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
Firstly disable it:

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
