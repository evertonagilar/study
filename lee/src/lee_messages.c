/*
 * %CopyrightBegin%
 *
 * Copyright Everton de Vargas Agilar 2022. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * %CopyrightEnd%
 */


#include <stdarg.h>
#include <stdio.h>
#include "lee_messages.h"

const char *MSG_EXPECTED_TOKEN_FORMAT = "Token %.*s expected but %.*s found.";
char lee_message_buf[250];

char *lee_format_message(const char *format, ...) {
    va_list args;
    va_start(args, format);
    vsnprintf(lee_message_buf, sizeof(lee_message_buf), format, args);
    va_end(args);
    return lee_message_buf;
}
