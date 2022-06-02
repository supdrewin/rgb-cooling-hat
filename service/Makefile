.PHONY: install uninstall

install:
	install -Dm644 i2c-pwm.service -t $(PREFIX)/lib/systemd/system

uninstall:
	$(RM) $(PREFIX)/lib/systemd/system/i2c-pwm.service
