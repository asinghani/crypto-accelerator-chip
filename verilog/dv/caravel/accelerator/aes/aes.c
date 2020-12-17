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

void run128(uint32_t key0, uint32_t key1, uint32_t key2, uint32_t key3,
            uint32_t iv0, uint32_t iv1, uint32_t iv2, uint32_t iv3,
            uint32_t in0, uint32_t in1, uint32_t in2, uint32_t in3,
            uint32_t out0, uint32_t out1, uint32_t out2, uint32_t out3,
            bool verbose, bool enc) {

    uint32_t aes_mask = 0x0;

    // Load key
    *((volatile uint32_t*) 0x30000040) = key0;
    *((volatile uint32_t*) 0x30000040) = key1;
    *((volatile uint32_t*) 0x30000040) = key2;
    *((volatile uint32_t*) 0x30000040) = key3;

    // Update key
    *((volatile uint32_t*) 0x3000000C) = 1;
    if (verbose) printstr("key\n");
    while((*((volatile uint32_t*) 0x30000000) & 0x3) != 0x3);

    // Set IV
    if (iv0 | iv1 | iv2 | iv3) {
        *((volatile uint32_t*) 0x30000000) = aes_mask | 0;
        *((volatile uint32_t*) 0x30000010) = 1194091594;
        *((volatile uint32_t*) 0x30000010) = 577847158;
        *((volatile uint32_t*) 0x30000010) = 1245724226;
        *((volatile uint32_t*) 0x30000010) = 1512654930;
        *((volatile uint32_t*) 0x30000008) = 1;

        while((*((volatile uint32_t*) 0x30000000) & 0x4) != 0x4);
        *((volatile uint32_t*) 0x30000000) = aes_mask | 8;
    } else {
        *((volatile uint32_t*) 0x30000000) = aes_mask | 0;
    }
    if (verbose) printstr("iv\n");

    // Load input data
    *((volatile uint32_t*) 0x30000010) = in0;
    *((volatile uint32_t*) 0x30000010) = in1;
    *((volatile uint32_t*) 0x30000010) = in2;
    *((volatile uint32_t*) 0x30000010) = in3;
    *((volatile uint32_t*) 0x30000004) = enc ? 1 : 2;
    if (verbose) printstr("data\n");

    while((*((volatile uint32_t*) 0x30000000) & 0x4) != 0x4);

    // Read back result
    if (*((volatile uint32_t*) 0x30000030) == out0 &&
        *((volatile uint32_t*) 0x30000034) == out1 &&
        *((volatile uint32_t*) 0x30000038) == out2 &&
        *((volatile uint32_t*) 0x3000003C) == out3) {
        printstr("PASS\n");
    } else {
        printstr("FAIL\n");
        verbose = 1;
    }

    if (verbose) {
        printhex(*((volatile uint32_t*) 0x30000030), true);
        printhex(*((volatile uint32_t*) 0x30000034), true);
        printhex(*((volatile uint32_t*) 0x30000038), true);
        printhex(*((volatile uint32_t*) 0x3000003C), true);
        printstr("\n");
    }

}

void main() {
    printstr("test\n");

    bool verbose = 0;

    // Load key as 114849718896073566083416993308083054187
    // Set IV to 94605682877008349257125771496548550738
    // Encrypt 54758945827980741386470298169332301409
    // Expect 63241459423936053969797744104158954336
    printstr("en1\n");
    run128(1449607251, 1734159223, 1713582630, 908945003,
           1194091594, 577847158, 1245724226, 1512654930,
           691155065, 845884219, 1382968177, 1333362273,
           798219438, 3687767725, 1414612439, 2930934624,
           verbose, 1);

    // Load key as 114849718896073566083416993308083054187
    // Set IV to 94605682877008349257125771496548550738
    // Decrypt 63241459423936053969797744104158954336
    // Expect 54758945827980741386470298169332301409
    printstr("de1\n");
    run128(1449607251, 1734159223, 1713582630, 908945003,
           1194091594, 577847158, 1245724226, 1512654930,
           798219438, 3687767725, 1414612439, 2930934624,
           691155065, 845884219, 1382968177, 1333362273,
           verbose, 0);

    printstr((char*)0x30000050);
    printstr("\n");


    endtest();
}


