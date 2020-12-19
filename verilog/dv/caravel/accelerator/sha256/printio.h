//SPDX-FileCopyrightText: 2020 Anish Singhani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0
void shift_char(char c) {
    *((volatile uint16_t*)(&reg_mprj_datal)) = (c << 8) | (*((volatile uint16_t*)(&reg_mprj_datal)) & 0xFF);

    reg_gpio_ena = 0;
    reg_gpio_data = 1;
    reg_gpio_data = 1;
    // should be enough delay to detect output
    reg_gpio_data = 0;
}

void setup_out() {
    reg_mprj_io_15 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_14 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_13 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_12 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_11 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_10 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_9  = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_8  = GPIO_MODE_MGMT_STD_OUTPUT;

    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);
}

void write_char(char c) {
    uint32_t tmp7 = reg_mprj_io_15;
    uint32_t tmp6 = reg_mprj_io_14;
    uint32_t tmp5 = reg_mprj_io_13;
    uint32_t tmp4 = reg_mprj_io_12;
    uint32_t tmp3 = reg_mprj_io_11;
    uint32_t tmp2 = reg_mprj_io_10;
    uint32_t tmp1 = reg_mprj_io_9;
    uint32_t tmp0 = reg_mprj_io_8;

    setup_out();

    shift_char(c);

    reg_mprj_io_15 = tmp7;
    reg_mprj_io_14 = tmp6;
    reg_mprj_io_13 = tmp5;
    reg_mprj_io_12 = tmp4;
    reg_mprj_io_11 = tmp3;
    reg_mprj_io_10 = tmp2;
    reg_mprj_io_9  = tmp1;
    reg_mprj_io_8  = tmp0;

    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);
}

void printhex(uint32_t x, bool newline) {
    uint32_t tmp7 = reg_mprj_io_15;
    uint32_t tmp6 = reg_mprj_io_14;
    uint32_t tmp5 = reg_mprj_io_13;
    uint32_t tmp4 = reg_mprj_io_12;
    uint32_t tmp3 = reg_mprj_io_11;
    uint32_t tmp2 = reg_mprj_io_10;
    uint32_t tmp1 = reg_mprj_io_9;
    uint32_t tmp0 = reg_mprj_io_8;

    setup_out();

    char *s = "0123456789abcdef";

    for (int i = 0; i < 8; i++) {
        shift_char(s[(x & 0xF0000000) >> 28]);
        x = x << 4;
    }
    if(newline) shift_char('\n');

    reg_mprj_io_15 = tmp7;
    reg_mprj_io_14 = tmp6;
    reg_mprj_io_13 = tmp5;
    reg_mprj_io_12 = tmp4;
    reg_mprj_io_11 = tmp3;
    reg_mprj_io_10 = tmp2;
    reg_mprj_io_9  = tmp1;
    reg_mprj_io_8  = tmp0;

    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);
}

void printstr(char *str) {
    uint32_t tmp7 = reg_mprj_io_15;
    uint32_t tmp6 = reg_mprj_io_14;
    uint32_t tmp5 = reg_mprj_io_13;
    uint32_t tmp4 = reg_mprj_io_12;
    uint32_t tmp3 = reg_mprj_io_11;
    uint32_t tmp2 = reg_mprj_io_10;
    uint32_t tmp1 = reg_mprj_io_9;
    uint32_t tmp0 = reg_mprj_io_8;

    setup_out();

    char c;
    while (*str) shift_char(*str++);

    reg_mprj_io_15 = tmp7;
    reg_mprj_io_14 = tmp6;
    reg_mprj_io_13 = tmp5;
    reg_mprj_io_12 = tmp4;
    reg_mprj_io_11 = tmp3;
    reg_mprj_io_10 = tmp2;
    reg_mprj_io_9  = tmp1;
    reg_mprj_io_8  = tmp0;

    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);
}

void endtest() {
    printstr("\x04");
}

