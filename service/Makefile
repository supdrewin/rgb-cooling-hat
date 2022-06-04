.PHONY: install uninstall

install:
	install -Dm755 rgb-cooling-hat -t $(PREFIX)/bin
	sed -i 's|%|$(PREFIX)|' $(PREFIX)/bin/rgb-cooling-hat

	install -Dm644 rgb-cooling-hat.service -t $(PREFIX)/lib/systemd/system
	sed -i 's|%|$(PREFIX)|' $(PREFIX)/lib/systemd/system/rgb-cooling-hat.service

uninstall:
	$(RM) $(PREFIX)/bin/rgb-cooling-hat
	$(RM) $(PREFIX)/lib/systemd/system/rgb-cooling-hat.service
