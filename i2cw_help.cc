/// i2cw_help.cc - Show help information for i2cw
/// Copyright (C) 2022  supdrewin
///
/// This Source Code Form is subject to the terms of the Mozilla Public
/// License, v. 2.0. If a copy of the MPL was not distributed with this
/// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#include <cstdio>
#include <cstdlib>
#include <cstring>

void help(char** argv, int status)
{
    int len = strlen(argv[0]),
        pos = len - 1;

    while (0 < pos && '/' != argv[0][pos]) {
        --pos;
    }

    const char* self = argv[0];

    if (++pos <= len) {
        self += pos;
    }

    printf(
        R"(
%s - Send data to devices via I2C protocol

usage:
  %s <-d id...> <-a addr> <-r byte> <-d b|w data>
  %s <-h|--help>

options:
  -a, --address                addr   i2c device address (hex)
  -i, --device                 id...  i2c file devices' id
  -d, --data <b, byte|w, word> data   send a byte/word of data (hex)
  -r, --register  byte                device register to access (hex)
  -h, --help                          show this help

)",
        self, self, self);

    exit(status);
}
