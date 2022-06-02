/// I2cDev.cc - Class implementation for I2C protocol
/// Copyright (C) 2022  supdrewin
///
/// This Source Code Form is subject to the terms of the Mozilla Public
/// License, v. 2.0. If a copy of the MPL was not distributed with this
/// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#include <fcntl.h>
#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <unistd.h>

#include "I2cDev.hh"
#include "macro.hh"

I2cDev::I2cDev(I2cDev&& dev)
    : filename(dev.filename)
{
}

I2cDev::I2cDev(String&& filename)
    : filename(filename)
{
}

I2cDev::I2cDev(String const& filename)
    : filename(filename)
{
}

void I2cDev::operator=(I2cDev&& dev)
{
    filename = std::move(dev.filename);
}

template <typename... Args>
int I2cDev::write(uint8_t addr, uint8_t reg,
    DataType type, Args... data) const
{
    match_and_return(open(filename.c_str(), O_RDWR), fd, fd < 0);
    write(fd, addr, reg, type, data...);

    return close(fd);
}

template <>
int I2cDev::write(uint8_t addr, uint8_t reg,
    DataType type, data_t data) const
{
    match_and_return(open(filename.c_str(), O_RDWR), fd, fd < 0);
    write(fd, addr, reg, type, data);

    return close(fd);
}

template <typename... Args>
int I2cDev::write(fd_t fd, uint8_t addr, uint8_t reg,
    DataType type, data_t data, Args... args) const
{
    match_and_return(write(fd, addr, reg, type, data), _, _ < 0);
    return write(fd, addr, reg, type, args...);
}

int I2cDev::write(fd_t fd, uint8_t addr, uint8_t reg,
    DataType type, data_t data) const
{
    match_and_return(ioctl(fd, I2C_SLAVE, addr), _, _ < 0);

    auto buf = (data << 8) + reg;
    return ::write(fd, &buf, type);
}
