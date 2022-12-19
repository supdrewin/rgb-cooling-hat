PREFIX := /usr

all: ssd1306 i2cw

ssd1306:
	-cargo build --release

i2cw:
	$(MAKE) PROJECT_ROOT=$(PWD) -C src

.PHONY: install uninstall clean

install: all
	$(MAKE) DIST=$(DIST) PREFIX=$(PREFIX) -C src install
	$(MAKE) DIST=$(DIST) PREFIX=$(PREFIX) -C scripts install
	$(MAKE) DIST=$(DIST) PREFIX=$(PREFIX) -C service install

	install -Dm644 LICENSE.md -t $(DIST)$(PREFIX)/share/licenses/rgb-cooling-hat
	-install -Dm755 target/release/rgb-cooling-hat $(DIST)$(PREFIX)/lib/rgb-cooling-hat/ssd1306

uninstall:
	$(MAKE) DIST=$(DIST) PREFIX=$(PREFIX) -C src uninstall
	$(MAKE) DIST=$(DIST) PREFIX=$(PREFIX) -C scripts uninstall
	$(MAKE) DIST=$(DIST) PREFIX=$(PREFIX) -C service uninstall

	$(RM) -r $(DIST)$(PREFIX)/share/licenses/rgb-cooling-hat
	-$(RM) $(DIST)$(PREFIX)/lib/rgb-cooling-hat/ssd1306

clean:
	$(MAKE) -C src clean
	-cargo clean
