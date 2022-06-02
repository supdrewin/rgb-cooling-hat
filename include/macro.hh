/// macro.hh - Define some useful macros
/// Copyright (C) 2022  supdrewin
///
/// This Source Code Form is subject to the terms of the Mozilla Public
/// License, v. 2.0. If a copy of the MPL was not distributed with this
/// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#pragma once

#define block(comment)

#define match_and_return(expr, lhs, condition) \
    auto lhs = expr;                           \
                                               \
    if (condition) {                           \
        return lhs;                            \
    }
