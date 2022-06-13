/// i2cw_help.cc - Show help information for i2cw
/// Copyright (C) 2022  supdrewin
///
/// This Source Code Form is subject to the terms of the Mozilla Public
/// License, v. 2.0. If a copy of the MPL was not distributed with this
/// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>

char const *HELP = R"(
% - Send data to devices via I2C protocol

usage:
  % -i <id...> -a <addr> -r <byte> -d <b|w> <data>
  % -i <id> -c <addr>
  % -h

options:
  -a, --address                  addr     i2c device address (hex)
  -c, --check                    addr     check if address (hex) available
  -d, --data <{b byte}|{w word}> data     send a byte/word of data (hex)
  -i, --device                   id[...]  i2c file device(s)' id
  -r, --register  byte                    device register to access (hex)
  -h, --help                              show this help

)";

inline size_t help_printf ( char const *fmt, char const *str )
{
	size_t len = 0;

	auto putc = [&len] ( auto pos ) {
		if ( EOF != putchar ( *pos ) ) ++len;
	};

	auto puts = [putc] ( auto pos ) {
		while ( 0 != *pos ) putc ( pos++ );
	};

	for ( ; 0 != *fmt; ++fmt ) '%' == *fmt ? puts ( str ) : putc ( fmt );

	return len;
}

void help ( char **argv, int status )
{
	int len = strlen ( argv[0] ), pos = len - 1;

	while ( 0 <= pos && '/' != argv[0][pos] ) --pos;

	char const *self = argv[0];

	if ( ++pos <= len ) self += pos;

	help_printf ( HELP, self );
	exit ( status );
}
