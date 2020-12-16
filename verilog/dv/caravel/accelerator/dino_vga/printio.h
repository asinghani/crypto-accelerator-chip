void shift_char(char c) {
    *((volatile char*)&reg_mprj_datal) = c;

    reg_gpio_ena = 0;
    reg_gpio_data = 1;
    reg_gpio_data = 1;
    // should be enough delay to detect output
    reg_gpio_data = 0;
}

void setup_out() {
    reg_mprj_io_7  = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_6  = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_5  = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_4  = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_3  = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_2  = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_1  = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_0  = GPIO_MODE_MGMT_STD_OUTPUT;

    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);
}

void write_char(char c) {
    uint32_t tmp7 = reg_mprj_io_7;
    uint32_t tmp6 = reg_mprj_io_6;
    uint32_t tmp5 = reg_mprj_io_5;
    uint32_t tmp4 = reg_mprj_io_4;
    uint32_t tmp3 = reg_mprj_io_3;
    uint32_t tmp2 = reg_mprj_io_2;
    uint32_t tmp1 = reg_mprj_io_1;
    uint32_t tmp0 = reg_mprj_io_0;

    setup_out();

    shift_char(c);

    reg_mprj_io_7 = tmp7;
    reg_mprj_io_6 = tmp6;
    reg_mprj_io_5 = tmp5;
    reg_mprj_io_4 = tmp4;
    reg_mprj_io_3 = tmp3;
    reg_mprj_io_2 = tmp2;
    reg_mprj_io_1 = tmp1;
    reg_mprj_io_0 = tmp0;

    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);
}

void printhex(uint32_t x, bool newline) {
    uint32_t tmp7 = reg_mprj_io_7;
    uint32_t tmp6 = reg_mprj_io_6;
    uint32_t tmp5 = reg_mprj_io_5;
    uint32_t tmp4 = reg_mprj_io_4;
    uint32_t tmp3 = reg_mprj_io_3;
    uint32_t tmp2 = reg_mprj_io_2;
    uint32_t tmp1 = reg_mprj_io_1;
    uint32_t tmp0 = reg_mprj_io_0;

    setup_out();

    char *s = "0123456789abcdef";

    for (int i = 0; i < 8; i++) {
        shift_char(s[(x & 0xF0000000) >> 28]);
        x = x << 4;
    }
    if(newline) shift_char('\n');

    reg_mprj_io_7 = tmp7;
    reg_mprj_io_6 = tmp6;
    reg_mprj_io_5 = tmp5;
    reg_mprj_io_4 = tmp4;
    reg_mprj_io_3 = tmp3;
    reg_mprj_io_2 = tmp2;
    reg_mprj_io_1 = tmp1;
    reg_mprj_io_0 = tmp0;

    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);
}

void printstr(char *str) {
    uint32_t tmp7 = reg_mprj_io_7;
    uint32_t tmp6 = reg_mprj_io_6;
    uint32_t tmp5 = reg_mprj_io_5;
    uint32_t tmp4 = reg_mprj_io_4;
    uint32_t tmp3 = reg_mprj_io_3;
    uint32_t tmp2 = reg_mprj_io_2;
    uint32_t tmp1 = reg_mprj_io_1;
    uint32_t tmp0 = reg_mprj_io_0;

    setup_out();

    char c;
    while (*str) shift_char(*str++);

    reg_mprj_io_7 = tmp7;
    reg_mprj_io_6 = tmp6;
    reg_mprj_io_5 = tmp5;
    reg_mprj_io_4 = tmp4;
    reg_mprj_io_3 = tmp3;
    reg_mprj_io_2 = tmp2;
    reg_mprj_io_1 = tmp1;
    reg_mprj_io_0 = tmp0;

    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);
}

void endtest() {
    printstr("\x04");
}
