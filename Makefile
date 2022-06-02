PREFIX := /usr

.PHONY: i2c-oled install uninstall clean

all: i2c-oled i2cw

i2c-oled:
	cargo build --release

i2cw:
	$(MAKE) PROJECT_ROOT=$(PWD) -C src

install: all
	$(MAKE) PREFIX=$(PREFIX) -C src install
	$(MAKE) PREFIX=$(PREFIX) -C scripts install
	$(MAKE) PREFIX=$(PREFIX) -C service install
	install -Dm755 target/release/i2c-oled -t $(PREFIX)/sbin
	install -Dm644 LICENSE.md -t $(PREFIX)/share/licenses/rgb-cooling-hat

uninstall:
	$(MAKE) PREFIX=$(PREFIX) -C src uninstall
	$(MAKE) PREFIX=$(PREFIX) -C scripts uninstall
	$(MAKE) PREFIX=$(PREFIX) -C service uninstall
	$(RM) $(PREFIX)/sbin/i2c-oled
	$(RM) -r $(PREFIX)/share/licenses/rgb-cooling-hat

clean:
	$(MAKE) -C src clean
	cargo clean
