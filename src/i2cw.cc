/// i2cw.cc - Send data to devices via I2C protocol
/// Copyright (C) 2022  supdrewin
///
/// This Source Code Form is subject to the terms of the Mozilla Public
/// License, v. 2.0. If a copy of the MPL was not distributed with this
/// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#include <algorithm>
#include <cstring>
#include <iostream>

#include "I2cDev.hh"
#include "macro.hh"

void help(char**, int);

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

    I2cDev::DataType type;
    I2cDev::data_t data;

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
            type = I2cDev::Byte;
        } else if ("word" == tp || "w" == tp) {
            type = I2cDev::Word;
        } else {
            std::cerr << "Invalid data type: "
                      << tp << std::endl;
            help(argv, EXIT_FAILURE);
        }

        data = static_cast<I2cDev::data_t>(std::stoi(
            iter->second[1], nullptr, 16));
    }

    auto status = EXIT_SUCCESS;

    for (auto& file : files) {
        if (0 > I2cDev(file).write(addr, reg, type, data)) {
            std::cerr << std::hex << "Failed to send data ["
                      << data << "] using register ["
                      << reg << "] to I2C device ["
                      << file << "] via address ["
                      << addr << "]!" << std::endl;

            status = EXIT_FAILURE;
        }
    }

    return status;
}
