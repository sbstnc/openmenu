#ifndef CRAYON_PERIPHERAL_H
#define CRAYON_PERIPHERAL_H

// This file contains functions and defines normally found in crayon

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h> // For the uintX_t types

#ifdef _arch_dreamcast

#include <dc/maple/vmu.h>
#include <dc/vmu_pkg.h>
#include <dc/vmufs.h>
#include <kos/fs.h>

#endif

#include "misc.h"

// Only used for port/slot in dreamcast. x is port, y is slot
typedef struct vec2_s8{
    int8_t x, y;
} vec2_s8_t;

vec2_s8_t crayon_peripheral_dreamcast_get_port_and_slot(int8_t savefile_device_id);

// Returns a bitmap of all vmus with a screen (a1a2b1b2c1c2d1d2)
uint8_t crayon_peripheral_dreamcast_get_screens();

void crayon_peripheral_vmu_display_icon(uint8_t vmu_bitmap, void *icon);

// 0 if the peripheral doesn't have the function, 1 if it does
// Kind of a Dreamcast-specific function, but for later console ports this might be reusable
uint8_t crayon_peripheral_has_function(uint32_t function, int8_t save_device_id);

#endif

