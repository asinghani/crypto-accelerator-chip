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

    // First test - small data
    printstr("test1\n");
    *((uint32_t*)0x30010000) =  0x1;
    *((uint32_t*)0x30010004) =  0x68656C6C;
    *((uint32_t*)0x30010004) =  0x6F800000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000028;
    while ((*((uint32_t*)0x30010000) & 0x4) != 0x4);

    if (*((uint32_t*)0x30010010) != 0x2CF24DBA) goto fail1;
    if (*((uint32_t*)0x30010014) != 0x5FB0A30E) goto fail1;
    if (*((uint32_t*)0x30010018) != 0x26E83B2A) goto fail1;
    if (*((uint32_t*)0x3001001C) != 0xC5B9E29E) goto fail1;
    if (*((uint32_t*)0x30010020) != 0x1B161E5C) goto fail1;
    if (*((uint32_t*)0x30010024) != 0x1FA7425E) goto fail1;
    if (*((uint32_t*)0x30010028) != 0x73043362) goto fail1;
    if (*((uint32_t*)0x3001002C) != 0x938B9824) goto fail1;
    goto pass1;

    fail1:
    printstr("Res: FAIL\n");
    printhex(*((uint32_t*)0x30010010), true);
    printhex(*((uint32_t*)0x30010014), true);
    printhex(*((uint32_t*)0x30010018), true);
    printhex(*((uint32_t*)0x3001001C), true);
    printhex(*((uint32_t*)0x30010020), true);
    printhex(*((uint32_t*)0x30010024), true);
    printhex(*((uint32_t*)0x30010028), true);
    printhex(*((uint32_t*)0x3001002C), true);
    goto done1;

    pass1:
    printstr("Res: PASS\n");

    done1:

    // Second test - larger data
    printstr("test2\n");
    *((uint32_t*)0x30010000) =  0x1;
    *((uint32_t*)0x30010004) =  0x33613537;
    *((uint32_t*)0x30010004) =  0x63643330;
    *((uint32_t*)0x30010004) =  0x35363066;
    *((uint32_t*)0x30010004) =  0x62326637;
    *((uint32_t*)0x30010004) =  0x32383361;
    *((uint32_t*)0x30010004) =  0x37343333;
    *((uint32_t*)0x30010004) =  0x65636539;
    *((uint32_t*)0x30010004) =  0x31393436;
    *((uint32_t*)0x30010004) =  0x61633664;
    *((uint32_t*)0x30010004) =  0x61346234;
    *((uint32_t*)0x30010004) =  0x30343063;
    *((uint32_t*)0x30010004) =  0x38633337;
    *((uint32_t*)0x30010004) =  0x61666135;
    *((uint32_t*)0x30010004) =  0x36343031;
    *((uint32_t*)0x30010004) =  0x39396465;
    *((uint32_t*)0x30010004) =  0x64353964;
    *((uint32_t*)0x30010004) =  0x80000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000000;
    *((uint32_t*)0x30010004) =  0x00000200;
    while ((*((uint32_t*)0x30010000) & 0x4) != 0x4);

    if (*((uint32_t*)0x30010010) != 0x41812DC6) goto fail2;
    if (*((uint32_t*)0x30010014) != 0x0561798D) goto fail2;
    if (*((uint32_t*)0x30010018) != 0xC0CC6E57) goto fail2;
    if (*((uint32_t*)0x3001001C) != 0x4B641893) goto fail2;
    if (*((uint32_t*)0x30010020) != 0xECF4186D) goto fail2;
    if (*((uint32_t*)0x30010024) != 0x4097283A) goto fail2;
    if (*((uint32_t*)0x30010028) != 0xF4A6CFF3) goto fail2;
    if (*((uint32_t*)0x3001002C) != 0xEDDAA4A0) goto fail2;
    goto pass2;

    fail2:
    printstr("Res: FAIL\n");
    printhex(*((uint32_t*)0x30010010), true);
    printhex(*((uint32_t*)0x30010014), true);
    printhex(*((uint32_t*)0x30010018), true);
    printhex(*((uint32_t*)0x3001001C), true);
    printhex(*((uint32_t*)0x30010020), true);
    printhex(*((uint32_t*)0x30010024), true);
    printhex(*((uint32_t*)0x30010028), true);
    printhex(*((uint32_t*)0x3001002C), true);
    goto done2;

    pass2:
    printstr("Res: PASS\n");

    done2:
    // Print identifier
    printstr("Res: ");
    printstr((char*)0x30010050);
    printstr("\n");

    endtest();
}


