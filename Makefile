CXXFLAGS += -pipe -O2

i2cw: i2cw.cc

.PHONY: i2c-oled install uninstall clean

i2c-oled:
	cd $@ && cargo b -r

install: i2cw i2c-oled
	install -Dm644 LICENSE.md -t /usr/share/licenses/rgb-cooling-hat
	install -Dm644 99-rgb-cooling-hat.rules -t /etc/udev/rules.d
	install -Dm644 i2c-pwm.service -t /lib/systemd/system
	install -Dm755 i2cw -t /sbin
	install -Dm755 i2c-oled/target/release/i2c-oled -t /sbin
	install -Dm755 pwm.sh /sbin/i2c-pwm
	install -Dm755 i2c-rgb.sh /sbin/i2c-rgb

uninstall:
	$(RM) -r /usr/share/licenses/rgb-cooling-hat
	$(RM) /etc/udev/rules.d/99-rgb-cooling-hat.rules
	$(RM) /lib/systemd/system/i2c-pwm.service
	$(RM) /sbin/i2cw
	$(RM) /sbin/i2c-oled
	$(RM) /sbin/i2c-pwm
	$(RM) /sbin/i2c-rgb

clean:
	cd i2c-oled && cargo clean
	$(RM) i2cw
