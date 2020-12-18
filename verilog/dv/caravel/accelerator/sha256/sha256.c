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
#include "../../defs.h"
#include "../../stub.c"
#include "printio.h"

void main() {
    printstr("test\n");

    bool verbose = 0;

    printstr((char*)0x30010050);
    printstr("\n");

    static uint32_t test_in1[] = {
        0x68656C6C, 0x6F800000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000028
    };
    unsigned int test_in1size = sizeof(test_in1) / sizeof(test_in1[0]);
	printhex(test_in1size, true);

    *((volatile uint32_t*)0x30010000) = 0x1;

    for (unsigned int i = 0; i < test_in1size; i++) {
        *((volatile uint32_t*)0x30010004) = test_in1[i];
        printhex(i, true);
    }
    while ((*((volatile uint32_t*)0x30010000) & 0x4) != 0x4);

    printhex(*((volatile uint32_t*)0x30010010), true);
    printhex(*((volatile uint32_t*)0x30010014), true);
    printhex(*((volatile uint32_t*)0x30010018), true);
    printhex(*((volatile uint32_t*)0x3001001C), true);
    printhex(*((volatile uint32_t*)0x30010020), true);
    printhex(*((volatile uint32_t*)0x30010024), true);
    printhex(*((volatile uint32_t*)0x30010028), true);
    printhex(*((volatile uint32_t*)0x3001002C), true);

    endtest();
}


