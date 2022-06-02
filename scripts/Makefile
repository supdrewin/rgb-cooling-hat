.PHONY: install uninstall

install:
	install -Dm755 i2c-fan.sh $(PREFIX)/sbin/i2c-fan
	install -Dm755 i2c-rgb.sh $(PREFIX)/sbin/i2c-rgb

uninstall:
	$(RM) $(PREFIX)/sbin/i2c-fan
	$(RM) $(PREFIX)/sbin/i2c-rgb
