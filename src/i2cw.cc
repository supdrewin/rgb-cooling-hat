/// i2cw.cc - Send data to devices via I2C protocol
/// Copyright (C) 2022  supdrewin
///
/// This Source Code Form is subject to the terms of the Mozilla Public
/// License, v. 2.0. If a copy of the MPL was not distributed with this
/// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#include <cstdlib>
#include <cstring>

#include <algorithm>
#include <iostream>
#include <map>
#include <string>
#include <vector>

#include "I2cDev.hh"

void help(char**, int) __attribute__((__noreturn__));

int main(int argc, char** argv)
{
    std::map<std::string, std::vector<std::string>> args;
    std::pair<std::string, std::vector<std::string>> pair;

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

#pragma mark help
    {
        auto iter = args.find("help");

        if (iter == args.end()) {
            iter = args.find("h");
        }

        if (iter != args.end()) {
            help(argv, EXIT_SUCCESS);
        }
    }
#pragma mark help

    auto devices = [&]() {
        auto iter = args.find("device");

        if (iter == args.end()) {
            iter = args.find("i");
        }

        if (iter == args.end()) {
            help(argv, EXIT_FAILURE);
        }

        return iter->second;
    }();

    auto getopti = [&](const char* l, const char* s) {
        auto iter = args.find(s);

        if (iter == args.end()) {
            iter = args.find(l);
        }

        if (iter == args.end() || 1 != iter->second.size()) {
            help(argv, EXIT_FAILURE);
        }

        return std::stoi(iter->second[0], nullptr, 16);
    };

    uint8_t addr = getopti("address", "a");
    uint8_t reg = getopti("register", "r");

    I2cDev::SingleData data = [&]() {
        auto iter = args.find("d");

        if (iter == args.end()) {
            iter = args.find("data");
        }

        if (iter == args.end() || 2 != iter->second.size()) {
            help(argv, EXIT_FAILURE);
        }

        auto data = std::stoi(iter->second[1], nullptr, 16);
        auto const& type = iter->second[0];

        if ("byte" == type || "b" == type) {
            return std::make_pair(I2cDev::Byte, data);
        }

        if ("word" == type || "w" == type) {
            return std::make_pair(I2cDev::Word, data);
        }

        std::cerr << "Invalid data type: "
                  << type << std::endl;
        help(argv, EXIT_FAILURE);
    }();

    auto status = EXIT_SUCCESS;

    for (auto& index : devices) {
        if (I2cDev(index, I2cDev::Index).write(addr, reg, data)
            != static_cast<int>(data.first)) {
            std::cerr << std::hex << "Failed to send data ["
                      << data.second << "] using register ["
                      << reg << "] to I2C device index ["
                      << index << "] via address ["
                      << addr << "]!" << std::endl;

            status = EXIT_FAILURE;
        }
    }

    return status;
}
