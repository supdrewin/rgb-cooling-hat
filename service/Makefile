.PHONY: install uninstall

install:
	install -Dm644 i2c-fan.service -t $(PREFIX)/lib/systemd/system

uninstall:
	$(RM) $(PREFIX)/lib/systemd/system/i2c-fan.service
