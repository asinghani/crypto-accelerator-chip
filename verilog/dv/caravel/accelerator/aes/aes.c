#include "../../defs.h"
#include "../../stub.c"
#include "printio.h"

void main() {
    printstr("test\n");
    printstr((char*)0x30000050);
    printstr("\n");

    // Load key as 114849718896073566083416993308083054187
    *((volatile uint32_t*) 0x30000040) = 1449607251;
    *((volatile uint32_t*) 0x30000040) = 1734159223;
    *((volatile uint32_t*) 0x30000040) = 1713582630;
    *((volatile uint32_t*) 0x30000040) = 908945003;

    // Update key
    *((volatile uint32_t*) 0x3000000C) = 1;
    printstr("key\n");
    while((*((volatile uint32_t*) 0x30000000) & 0x3) != 0x3);

    // Set IV to 94605682877008349257125771496548550738
    *((volatile uint32_t*) 0x30000000) = 0;
    *((volatile uint32_t*) 0x30000010) = 1194091594;
    *((volatile uint32_t*) 0x30000010) = 577847158;
    *((volatile uint32_t*) 0x30000010) = 1245724226;
    *((volatile uint32_t*) 0x30000010) = 1512654930;
    *((volatile uint32_t*) 0x30000008) = 1;
    printstr("iv\n");
    while((*((volatile uint32_t*) 0x30000000) & 0x4) != 0x4);
    *((volatile uint32_t*) 0x30000000) = 8;

    // Encrypt 54758945827980741386470298169332301409
    *((volatile uint32_t*) 0x30000010) = 691155065;
    *((volatile uint32_t*) 0x30000010) = 845884219;
    *((volatile uint32_t*) 0x30000010) = 1382968177;
    *((volatile uint32_t*) 0x30000010) = 1333362273;
    *((volatile uint32_t*) 0x30000004) = 1;
    printstr("enc\n");
    while((*((volatile uint32_t*) 0x30000000) & 0x4) != 0x4);

    // Read back result
    printhex(*((volatile uint32_t*) 0x30000030), true); // should be 2f93dcae
    printhex(*((volatile uint32_t*) 0x30000034), true); // should be dbcedead
    printhex(*((volatile uint32_t*) 0x30000038), true); // should be 545145d7
    printhex(*((volatile uint32_t*) 0x3000003C), true); // should be aeb28360

    endtest();
}

