CXXFLAGS += \
	-I$(PROJECT_ROOT)/include \
	-O2 -flto -fno-exceptions -pedantic -pipe \
	-Wall -Wextra -Wsign-conversion

i2cw: i2cw.cc i2cw_help.cc I2cDev.o

I2cDev.o: I2cDev.cc

.PHONY: install uninstall clean

install: i2cw
	install -Dm755 i2cw -t $(PREFIX)/sbin

uninstall:
	$(RM) $(PREFIX)/sbin/i2cw

clean:
	$(RM) I2cDev.o i2cw
