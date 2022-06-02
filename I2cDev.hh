/// I2cDev.hh - Class declaration for I2C protocol
/// Copyright (C) 2022  supdrewin
///
/// This Source Code Form is subject to the terms of the Mozilla Public
/// License, v. 2.0. If a copy of the MPL was not distributed with this
/// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#pragma once

#include "type.hh"

class I2cDev {
public:
    using data_t = uint32_t;
    using fd_t = int;

    enum DataType : size_t {
        Byte = 2,
        Word = 3,
    };

    I2cDev(I2cDev&& dev);

    I2cDev(String&& filename);
    I2cDev(String const& filename);

    void operator=(I2cDev&& dev);

    template <typename... Args>
    int write(uint8_t addr, uint8_t reg,
        DataType type, Args... data) const;

    template <typename... Args>
    int write(fd_t fd, uint8_t addr, uint8_t reg,
        DataType type, data_t data, Args... args) const;

    int write(fd_t fd, uint8_t addr, uint8_t reg,
        DataType type, data_t data) const;

private:
    String filename;
};
