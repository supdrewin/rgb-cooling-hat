/// type.hh - Define typenames from STL if needed
/// Copyright (C) 2022  supdrewin
///
/// This Source Code Form is subject to the terms of the Mozilla Public
/// License, v. 2.0. If a copy of the MPL was not distributed with this
/// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#pragma once

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

#include <cstddef>
#include <cstdint>
