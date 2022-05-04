i2cw: i2cw.cc

.PHONY: install uninstall clean

install: i2cw
	install -Dm644 99-rgb-cooling-hat.rules -t /etc/udev/rules.d
	install -Dm644 i2c-pwm.service -t /lib/systemd/system
	install -Dm755 i2cw -t /sbin
	install -Dm755 pwm.sh /sbin/i2c-pwm

uninstall:
	$(RM) /etc/udev/rules.d/99-rgb-cooling-hat.rules
	$(RM) /lib/systemd/system/i2c-pwm.service
	$(RM) /sbin/i2cw
	$(RM) /sbin/i2c-pwm

clean:
	$(RM) i2cw
