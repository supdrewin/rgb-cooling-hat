i2cw: i2cw.cc

.PHONY: install uninstall clean

install: i2cw
	install -Dm644 99-rgb-cooling-hat.rules -t /etc/udev/rules.d
	install -Dm755 i2cw -t /sbin
	install -Dm755 pwm.sh /sbin/i2c-pwm

uninstall:
	$(RM) /etc/udev/rules.d/99-rgb-cooling-hat.rules
	$(RM) /sbin/i2cw
	$(RM) /sbin/i2c-pwm

clean:
	$(RM) i2cw
