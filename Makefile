i2cw: i2cw.cc

.PHONY: install uninstall clean

install: i2cw
	install -Dm755 i2cw -t /sbin
	install -Dm644 99-rgb-cooling-hat.rules -t /etc/udev/rules.d

uninstall:
	$(RM) /sbin/i2cw
	$(RM) /etc/udev/rules.d/99-rgb-cooling-hat.rules

clean:
	$(RM) i2cw
