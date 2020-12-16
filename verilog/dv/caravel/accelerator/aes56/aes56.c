#include "../../defs.h"
#include "../../stub.c"
#include "printio.h"

void main() {
    printstr("test\n");

    // Load key as 129398247407752897397544612226629132633
    *((volatile uint32_t*) 0x30000040) = 1633235497;
    *((volatile uint32_t*) 0x30000040) = 1483818081;
    *((volatile uint32_t*) 0x30000040) = 1496459608;
    *((volatile uint32_t*) 0x30000040) = 1900306777;

    // Update key
    *((volatile uint32_t*) 0x3000000C) = 1;
    printstr("key\n");
    while((*((volatile uint32_t*) 0x30000000) & 0x3) != 0x3);

    // Set IV to 114699768982221135679306289480750232887
    *((volatile uint32_t*) 0x30000000) = 0;
    *((volatile uint32_t*) 0x30000010) = 1447714617;
    *((volatile uint32_t*) 0x30000010) = 1749315923;
    *((volatile uint32_t*) 0x30000010) = 1784438134;
    *((volatile uint32_t*) 0x30000010) = 1076524343;
    *((volatile uint32_t*) 0x30000008) = 1;
    printstr("iv\n");
    while((*((volatile uint32_t*) 0x30000000) & 0x4) != 0x4);
    *((volatile uint32_t*) 0x30000000) = 8;

    // Encrypt 165172891330934591086520181724919193936
    *((volatile uint32_t*) 0x30000010) = 2084774985;
    *((volatile uint32_t*) 0x30000010) = 741680718;
    *((volatile uint32_t*) 0x30000010) = 1060196990;
    *((volatile uint32_t*) 0x30000010) = 963469648;
    *((volatile uint32_t*) 0x30000004) = 1;
    printstr("enc\n");
    while((*((volatile uint32_t*) 0x30000000) & 0x4) != 0x4);

    // Read back result
    printhex(*((volatile uint32_t*) 0x30000030), true); // should be 99aed01a
    printhex(*((volatile uint32_t*) 0x30000034), true); // should be 4979c429
    printhex(*((volatile uint32_t*) 0x30000038), true); // should be ce53fad4
    printhex(*((volatile uint32_t*) 0x3000003C), true); // should be 9cf95a53

    endtest();
}

