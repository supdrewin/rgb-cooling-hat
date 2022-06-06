# RGB Cooling HAT

RGB Cooling HAT advanced utility for
`YB-EPV02` and it's `SSD1306`.

### Features

- Auto changes the fan speed according to current tempearture.
- Full manager utility `rgb-cooling-hat` for fan/RGB control.
- Provides I2C write (8/16 Bit) feature via `i2cw` command.
- Show current `Freq` and `Temp` if OLED display available.

### Usage

Type `rgb-cooling-hat help` to show information.

The custom RGB script is stored in `/etc/rgb-cooling-hat/rgb`,
content insides this script will apply at boot.

Example content of `/etc/rgb-cooling-hat/rgb`:

``` shell
cmdline rgb --select 1 --color 0xff0000
cmdline rgb --select 2 --color 0x00ff00
cmdline rgb --select 3 --color 0x0000ff
```

Note: Please DON'T push commands spend long time into `rgb`,
otherwise it will block anything.

### Pre-required

Hardware:
- `YB-EPV02` and compatable board
  (e.g. Raspberry Pi, Rock Pi...)
- Enable I2C feature for GPIO pins
  (using device tree overlay)

Dependency:
- bash
- systemd (optional)
- cargo (make)
- git (make)

### Install

- Arch Linux

  change `pwd` into subdir `AUR`,
  then using `makepkg`:

  ``` shell
  $ makepkg -csi
  ```

- Others

  Install all files:

  ``` shell
  $ make install
  ```

  Optional enable the fan control service:

  ``` shell
  $ systemctl enable --now rgb-cooling-hat
  ```

### Uninstall

If you enable the fan control service previous,
firstly disable it:

``` shell
$ systemctl disable --now rgb-cooling-hat
```

Uninstall all files:

``` shell
$ make uninstall
```

### License

This repository is unofficial and working myself,
all code of this repository are under `MPL-2.0`,
so any modifies should be open source.
