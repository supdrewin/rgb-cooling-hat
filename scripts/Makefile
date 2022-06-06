.PHONY: install uninstall

install:
	install -Dm755 config.sh -t $(PREFIX)/lib/rgb-cooling-hat
	-install -dm755 /etc/rgb-cooling-hat

	install -Dm755 fan.sh -t $(PREFIX)/lib/rgb-cooling-hat
	sed -i 's|%{prefix}|$(PREFIX)|' $(PREFIX)/lib/rgb-cooling-hat/fan.sh

	install -Dm755 rgb.sh -t $(PREFIX)/lib/rgb-cooling-hat
	sed -i 's|%{prefix}|$(PREFIX)|' $(PREFIX)/lib/rgb-cooling-hat/rgb.sh

	install -Dm755 main.sh -t $(PREFIX)/lib/rgb-cooling-hat
	sed -i 's|%{prefix}|$(PREFIX)|' $(PREFIX)/lib/rgb-cooling-hat/main.sh

	((PACKAGE_ENV == 1)) || ln -fs \
		$(PREFIX)/lib/rgb-cooling-hat/main.sh \
		$(PREFIX)/bin/rgb-cooling-hat

uninstall:
	$(RM) -r $(PREFIX)/lib/rgb-cooling-hat
	$(RM) $(PREFIX)/bin/rgb-cooling-hat
