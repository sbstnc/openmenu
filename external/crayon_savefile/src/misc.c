#include "crayon_savefile/misc.h"

uint8_t
crayon_misc_is_big_endian() {
    int a = 1;
    return !((char*)&a)[0];
}

void
crayon_misc_endian_correction(uint8_t* buffer, size_t bytes) {
    ;

    return;
}

void
crayon_misc_encode_to_buffer(uint8_t* buffer, uint8_t* data, size_t bytes) {
    while (bytes--) {
        *buffer++ = *data++;
    }

    return;
}
