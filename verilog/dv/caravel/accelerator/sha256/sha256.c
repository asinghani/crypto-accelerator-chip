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
    reg_spimaster_config = 0xA002; // Allow use of pin3
    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);

    printstr("test\n");

    bool verbose = 0;

    unsigned int test_in1size = 16;
	printhex(test_in1size, true);

    *((volatile uint32_t*)0x30010000) = 0x1;
    *((volatile uint32_t*)0x30010004) =  0x68656C6C;
    *((volatile uint32_t*)0x30010004) =  0x6F800000;
    *((volatile uint32_t*)0x30010004) =  0x00000000;
    *((volatile uint32_t*)0x30010004) =  0x00000000;
    *((volatile uint32_t*)0x30010004) =  0x00000000;
    *((volatile uint32_t*)0x30010004) =  0x00000000;
    *((volatile uint32_t*)0x30010004) =  0x00000000;
    *((volatile uint32_t*)0x30010004) =  0x00000000;
    printstr("1\n");

    *((volatile uint32_t*)0x30010004) =  0x00000000;
    *((volatile uint32_t*)0x30010004) =  0x00000000;
    *((volatile uint32_t*)0x30010004) =  0x00000000;
    *((volatile uint32_t*)0x30010004) =  0x00000000;
    *((volatile uint32_t*)0x30010004) =  0x00000000;
    *((volatile uint32_t*)0x30010004) =  0x00000000;
    *((volatile uint32_t*)0x30010004) =  0x00000000;
    *((volatile uint32_t*)0x30010004) =  0x00000028;
    printstr("2\n");
    while ((*((volatile uint32_t*)0x30010000) & 0x4) != 0x4);


    // 0x2CF24DBA
    // 0x5FB0A30E
    // 0x26E83B2A
    // 0xC5B9E29E
    // 0x1B161E5C
    // 0x1FA7425E
    // 0x73043362
    // 0x938B9824
    printhex(*((volatile uint32_t*)0x30010010), true);
    printhex(*((volatile uint32_t*)0x30010014), true);
    printhex(*((volatile uint32_t*)0x30010018), true);
    printhex(*((volatile uint32_t*)0x3001001C), true);
    printhex(*((volatile uint32_t*)0x30010020), true);
    printhex(*((volatile uint32_t*)0x30010024), true);
    printhex(*((volatile uint32_t*)0x30010028), true);
    printhex(*((volatile uint32_t*)0x3001002C), true);

    printstr((char*)0x30010050);
    printstr("\n");

    endtest();
}


