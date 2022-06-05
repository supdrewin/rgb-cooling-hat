/// I2cDev.hh - Class declaration for I2C protocol
/// Copyright (C) 2022  supdrewin
///
/// This Source Code Form is subject to the terms of the Mozilla Public
/// License, v. 2.0. If a copy of the MPL was not distributed with this
/// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#pragma once

#include <cstddef>
#include <cstdint>

#include <string>
#include <utility>

class I2cDev {
public:
    enum InitType {
        Index,
        Path,
    };

    enum DataLen : size_t {
        Byte = 2,
        Word = 3,
    };

    using data_t = uint32_t;
    using fd_t = int;

    using SingleData = std::pair<DataLen, data_t>;

    I2cDev(I2cDev&& dev);

    I2cDev(std::string const& raw, InitType tp);

    void operator=(I2cDev&& dev);

    bool is_available(uint8_t addr) const;

    fd_t open() const;

    int read(uint8_t addr, SingleData& data) const;

    int read(fd_t fd, uint8_t addr, SingleData& data) const;

    template <typename... Args>
    int write(uint8_t addr, uint8_t reg,
        DataLen len, Args... data) const;

    int write(uint8_t addr, uint8_t reg,
        SingleData data) const;

    template <typename... Args>
    int write(fd_t fd, uint8_t addr, uint8_t reg,
        DataLen len, data_t data, Args... args) const;

    int write(fd_t fd, uint8_t addr, uint8_t reg,
        DataLen len, data_t data) const;

    int write(fd_t fd, uint8_t addr, uint8_t reg,
        SingleData data) const;

private:
    std::string filename;
};
