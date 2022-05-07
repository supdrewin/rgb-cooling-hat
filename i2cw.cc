/// i2cw.cc - Send data to devices via I2C protocol
/// Copyright (C) 2022  supdrewin
///
/// This Source Code Form is subject to the terms of the Mozilla Public
/// License, v. 2.0. If a copy of the MPL was not distributed with this
/// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#include <string>

using String = std::string;

#include <unordered_map>

template <typename K, typename V>
using HashMap = std::unordered_map<K, V>;

#include <utility>

template <typename K, typename V>
using Pair = std::pair<K, V>;

#include <vector>

template <typename T>
using Vec = std::vector<T>;

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>

extern "C" {
#include <linux/i2c-dev.h>
}

#if defined(DEBUG)
#include <iostream>
#endif

#define block(comment)

enum DataType : size_t {
    Byte = 2,
    Word = 3,
};

void help(char** argv, int state)
{
    int len = strlen(argv[0]),
        pos = len - 1;

    while (0 < pos && '/' != argv[0][pos]) {
        --pos;
    }

    const char* prog = argv[0];

    if (++pos <= len) {
        prog += pos;
    }

    printf("\n"
           "%s - Send data to devices via I2C protocol\n"
           "\n"
           "usage:\n"
           "  %s <-d id...> <-a addr> <-r byte> <-d b|w data>\n"
           "  %s <-h|--help>\n"
           "\n"
           "options:\n"
           "  -a, --address                addr   i2c device address (hex)\n"
           "  -i, --device                 id...  i2c file devices' id\n"
           "  -d, --data <b, byte|w, word> data   send a byte/word of data (hex)\n"
           "  -r, --register  byte                device register to access (hex)\n"
           "  -h, --help                          show this help\n"
           "\n",
        prog, prog, prog);

    exit(state);
}

int main(int argc, char** argv)
{
    HashMap<String, Vec<String>> args;
    Pair<String, Vec<String>> pair;

    for (int i = 1; i < argc; ++i) {
        auto pos = std::find_if(
            argv[i], argv[i] + strlen(argv[i]),
            [](char c) {
                return '-' != c;
            });

        switch (pos - argv[i]) {
        case 0:
            pair.second.push_back(argv[i]);
            break;
        case 1:
        case 2: {
            if (!pair.first.empty()) {
                args.insert(std::move(pair));
            }

            pair.first = pos;
            break;
        }
        default:
            help(argv, EXIT_FAILURE);
        }
    }

    if (!pair.first.empty()) {
        args.insert(std::move(pair));
    }

#if defined(DEBUG)
    std::cout << "\nargs: {";

    for (auto& arg : args) {
        std::cout << "\n\t" << arg.first << ": [";

        for (auto& v : arg.second) {
            std::cout << "\n\t\t" << v << ',';
        }

        std::cout << "\n\t],";
    }

    std::cout << "\n}\n\n";
#endif

    block(help)
    {
        auto iter = args.find("help");

        if (iter == args.end()) {
            iter = args.find("h");
        }

        if (iter != args.end()) {
            help(argv, EXIT_SUCCESS);
        }
    }

    Vec<String> files;

    block(device)
    {
        auto iter = args.find("device");

        if (iter == args.end()) {
            iter = args.find("i");
        }

        if (iter == args.end()) {
            help(argv, EXIT_FAILURE);
        }

        for (auto& id : iter->second) {
            files.push_back("/dev/i2c-" + id);
        }
    }

    auto getopti = [&](const char* l, const char* s) {
        auto iter = args.find(l);

        if (iter == args.end()) {
            iter = args.find(s);
        }

        if (iter == args.end() || 1 != iter->second.size()) {
            help(argv, EXIT_FAILURE);
        }

        return std::stoi(iter->second[0], nullptr, 16);
    };

    uint8_t addr = getopti("address", "a");
    uint8_t reg = getopti("register", "r");

    DataType type;
    uint16_t data;

    block(data)
    {
        auto iter = args.find("data");

        if (iter == args.end()) {
            iter = args.find("d");
        }

        if (iter == args.end() || 2 != iter->second.size()) {
            help(argv, EXIT_FAILURE);
        }

        auto const& tp = iter->second[0];

        if ("byte" == tp || "b" == tp) {
            type = DataType::Byte;
        } else if ("word" == tp || "w" == tp) {
            type = DataType::Word;
        } else {
            printf("Invalid data type: %s\n", tp.c_str());
            help(argv, EXIT_FAILURE);
        }

        data = std::stoi(iter->second[1], nullptr, 16);
    }

    for (auto& file : files) {
        auto f = file.c_str();
        auto fd = open(f, O_RDWR);

        if (0 > fd) {
            printf("Failed to open \"%s\"\n", f);
            exit(EXIT_FAILURE);
        }

        if (0 > ioctl(fd, I2C_SLAVE, addr)) {
            printf("Invalid address: %#4x\n", addr);
            exit(EXIT_FAILURE);
        }

        auto buf = (data << 8) + reg;

        if (0 > write(fd, &buf, type)) {
            printf("Failed to write data: %x\n", buf);
            exit(EXIT_FAILURE);
        }
    }

    return EXIT_SUCCESS;
}
