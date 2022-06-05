/// I2cDev.cc - Class implementation for I2C protocol
/// Copyright (C) 2022  supdrewin
///
/// This Source Code Form is subject to the terms of the Mozilla Public
/// License, v. 2.0. If a copy of the MPL was not distributed with this
/// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#include <sys/fcntl.h>
#include <sys/ioctl.h>
#include <sys/unistd.h>

#include "I2cDev.hh"

I2cDev::I2cDev(I2cDev&& dev)
    : filename(dev.filename)
{
}

I2cDev::I2cDev(std::string const& raw, InitType tp)
    : filename(tp == InitType::Index
            ? "/dev/i2c-" + raw
            : raw)
{
}

void I2cDev::operator=(I2cDev&& dev)
{
    filename = std::move(dev.filename);
}

bool I2cDev::is_available(uint8_t addr) const
{
    SingleData data = std::make_pair(DataLen::Byte, 0);
    return read(addr, data) == static_cast<int>(data.first);
}

I2cDev::fd_t I2cDev::open() const
{
    return ::open(filename.c_str(), O_RDWR);
}

int I2cDev::read(uint8_t addr, SingleData& data) const
{
    auto fd = open();

    if (-1 == fd) {
        return fd;
    }

    read(fd, addr, data);
    return close(fd);
}

int I2cDev::read(fd_t fd, uint8_t addr, SingleData& data) const
{
    auto error = ioctl(fd, 0x0703, addr);

    if (0 > error) {
        return error;
    }

    return ::read(fd, &data.second, data.first);
}

template <typename... Args>
int I2cDev::write(uint8_t addr, uint8_t reg,
    DataLen len, Args... data) const
{
    auto fd = open();

    if (0 > fd) {
        return fd;
    }

    write(fd, addr, reg, len, data...);
    return close(fd);
}

template <>
int I2cDev::write(uint8_t addr, uint8_t reg,
    DataLen len, data_t data) const
{
    auto fd = open();

    if (-1 == fd) {
        return fd;
    }

    write(fd, addr, reg, len, data);
    return close(fd);
}

int I2cDev::write(uint8_t addr, uint8_t reg,
    SingleData data) const
{
    return write(addr, reg, data.first, data.second);
}

template <typename... Args>
int I2cDev::write(fd_t fd, uint8_t addr, uint8_t reg,
    DataLen len, data_t data, Args... args) const
{
    auto real_len = write(fd, addr, reg, len, data);

    if (real_len != static_cast<int>(len)) {
        return real_len;
    }

    return write(fd, addr, reg, len, args...);
}

int I2cDev::write(fd_t fd, uint8_t addr, uint8_t reg,
    DataLen len, data_t data) const
{
    auto error = ioctl(fd, 0x0703, addr);

    if (0 > error) {
        return error;
    }

    auto buf = (data << 8) + reg;
    return ::write(fd, &buf, len);
}

int I2cDev::write(fd_t fd, uint8_t addr, uint8_t reg,
    SingleData data) const
{
    return write(fd, addr, reg, data.first, data.second);
}
