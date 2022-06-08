.PHONY: install uninstall

install:
	install -Dm644 rgb-cooling-hat.service -t $(PREFIX)/lib/systemd/system
	sed -i 's|%{prefix}|$(PREFIX)|' $(PREFIX)/lib/systemd/system/rgb-cooling-hat.service

	install -Dm644 rgb-cooling-hat.oled.service -t $(PREFIX)/lib/systemd/system
	sed -i 's|%{prefix}|$(PREFIX)|' $(PREFIX)/lib/systemd/system/rgb-cooling-hat.oled.service

uninstall:
	$(RM) $(PREFIX)/lib/systemd/system/rgb-cooling-hat.service
	$(RM) $(PREFIX)/lib/systemd/system/rgb-cooling-hat.oled.service
