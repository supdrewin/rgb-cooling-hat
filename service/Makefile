.PHONY: install uninstall

install:
	install -Dm644 rgb-cooling-hat.service -t $(DIST)$(PREFIX)/lib/systemd/system
	sed -i 's|%{prefix}|$(PREFIX)|' $(DIST)$(PREFIX)/lib/systemd/system/rgb-cooling-hat.service

	install -Dm644 rgb-cooling-hat.oled.service -t $(DIST)$(PREFIX)/lib/systemd/system
	sed -i 's|%{prefix}|$(PREFIX)|' $(DIST)$(PREFIX)/lib/systemd/system/rgb-cooling-hat.oled.service

uninstall:
	$(RM) $(DIST)$(PREFIX)/lib/systemd/system/rgb-cooling-hat.service
	$(RM) $(DIST)$(PREFIX)/lib/systemd/system/rgb-cooling-hat.oled.service
