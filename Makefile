PREFIX := /usr

all: ssd1306 i2cw

ssd1306:
	cargo build --release

i2cw:
	$(MAKE) PROJECT_ROOT=$(PWD) -C src

.PHONY: install uninstall clean

install: all
	$(MAKE) PREFIX=$(PREFIX) -C src install
	$(MAKE) PREFIX=$(PREFIX) -C scripts install
	$(MAKE) PREFIX=$(PREFIX) -C service install

	install -Dm755 target/release/rgb-cooling-hat $(PREFIX)/lib/rgb-cooling-hat/ssd1306
	install -Dm644 LICENSE.md -t $(PREFIX)/share/licenses/rgb-cooling-hat

uninstall:
	$(MAKE) PREFIX=$(PREFIX) -C src uninstall
	$(MAKE) PREFIX=$(PREFIX) -C scripts uninstall
	$(MAKE) PREFIX=$(PREFIX) -C service uninstall

	$(RM) $(PREFIX)/lib/rgb-cooling-hat/ssd1306
	$(RM) -r $(PREFIX)/share/licenses/rgb-cooling-hat

clean:
	$(MAKE) -C src clean
	cargo clean
