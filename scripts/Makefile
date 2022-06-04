.PHONY: install uninstall

install:
	install -Dm755 env.sh -t $(PREFIX)/lib/rgb-cooling-hat

	install -Dm755 fan.sh -t $(PREFIX)/lib/rgb-cooling-hat
	sed -i 's|%|$(PREFIX)|' $(PREFIX)/lib/rgb-cooling-hat/fan.sh

	install -Dm755 rgb.sh -t $(PREFIX)/lib/rgb-cooling-hat
	sed -i 's|%|$(PREFIX)|' $(PREFIX)/lib/rgb-cooling-hat/rgb.sh

uninstall:
	$(RM) -r $(PREFIX)/lib/rgb-cooling-hat
