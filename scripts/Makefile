.PHONY: install uninstall

install:
	install -Dm755 i2c-pwm.sh $(PREFIX)/sbin/i2c-pwm
	install -Dm755 i2c-rgb.sh $(PREFIX)/sbin/i2c-rgb

uninstall:
	$(RM) $(PREFIX)/sbin/i2c-pwm
	$(RM) $(PREFIX)/sbin/i2c-rgb
