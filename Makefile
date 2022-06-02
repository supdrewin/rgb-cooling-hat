CXXFLAGS += \
	-O2 -flto -fno-exceptions -pedantic -pipe \
	-Wall -Wextra -Wsign-conversion

all: i2cw i2c-oled

I2cDev.o: I2cDev.cc I2cDev.hh

i2cw: i2cw.cc i2cw_help.cc I2cDev.o

.PHONY: i2c-oled install uninstall clean

i2c-oled:
	cd $@ && cargo build --release

install: all
	install -Dm644 LICENSE.md -t /usr/share/licenses/rgb-cooling-hat
	install -Dm644 i2c-pwm.service -t /lib/systemd/system
	install -Dm755 i2cw -t /sbin
	install -Dm755 i2c-oled/target/release/i2c-oled -t /sbin
	install -Dm755 i2c-pwm.sh /sbin/i2c-pwm
	install -Dm755 i2c-rgb.sh /sbin/i2c-rgb

uninstall:
	$(RM) -r /usr/share/licenses/rgb-cooling-hat
	$(RM) /lib/systemd/system/i2c-pwm.service
	$(RM) /sbin/i2cw
	$(RM) /sbin/i2c-oled
	$(RM) /sbin/i2c-pwm
	$(RM) /sbin/i2c-rgb

clean:
	cd i2c-oled && cargo clean
	$(RM) I2cDev.o i2cw
