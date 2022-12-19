.PHONY: install uninstall

install:
	install -Dm755 config.sh -t $(DIST)$(PREFIX)/lib/rgb-cooling-hat
	-install -dm755 $(DIST)/etc/rgb-cooling-hat

	install -Dm755 fan.sh -t $(DIST)$(PREFIX)/lib/rgb-cooling-hat
	sed -i 's|%{prefix}|$(PREFIX)|' $(DIST)$(PREFIX)/lib/rgb-cooling-hat/fan.sh

	install -Dm755 rgb.sh -t $(DIST)$(PREFIX)/lib/rgb-cooling-hat
	sed -i 's|%{prefix}|$(PREFIX)|' $(DIST)$(PREFIX)/lib/rgb-cooling-hat/rgb.sh

	install -Dm755 oled.sh -t $(DIST)$(PREFIX)/lib/rgb-cooling-hat
	sed -i 's|%{prefix}|$(PREFIX)|' $(DIST)$(PREFIX)/lib/rgb-cooling-hat/oled.sh

	install -Dm755 main.sh -t $(DIST)$(PREFIX)/lib/rgb-cooling-hat
	sed -i 's|%{prefix}|$(PREFIX)|' $(DIST)$(PREFIX)/lib/rgb-cooling-hat/main.sh

	((PACKAGE_ENV == 1)) || ln -fs \
		$(DIST)$(PREFIX)/lib/rgb-cooling-hat/main.sh \
		$(DIST)$(PREFIX)/bin/rgb-cooling-hat

uninstall:
	$(RM) -r $(DIST)$(PREFIX)/lib/rgb-cooling-hat
	$(RM) $(DIST)$(PREFIX)/bin/rgb-cooling-hat
