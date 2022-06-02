PREFIX := /usr

.PHONY: i2c-oled install uninstall clean

all: i2c-oled
	 $(MAKE) PROJECT_ROOT=$(PWD) -C src

i2c-oled:
	cargo build --release

install: all
	$(MAKE) PREFIX=$(PREFIX) -C src install
	$(MAKE) PREFIX=$(PREFIX) -C scripts install
	install -Dm755 target/release/i2c-oled -t $(PREFIX)/sbin
	install -Dm644 LICENSE.md -t $(PREFIX)/share/licenses/rgb-cooling-hat
	install -Dm644 i2c-pwm.service -t $(PREFIX)/lib/systemd/system

uninstall:
	$(MAKE) PREFIX=$(PREFIX) -C src uninstall
	$(MAKE) PREFIX=$(PREFIX) -C scripts uninstall
	$(RM) $(PREFIX)/sbin/i2c-oled
	$(RM) -r $(PREFIX)/share/licenses/rgb-cooling-hat
	$(RM) $(PREFIX)/lib/systemd/system/i2c-pwm.service

clean:
	$(MAKE) -C src clean
	cargo clean
