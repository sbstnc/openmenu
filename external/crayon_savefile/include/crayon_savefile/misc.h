#ifndef CRAYON_MISC_H
#define CRAYON_MISC_H

// This file contains functions and defines normally found in crayon

#if defined(__APPLE__) || defined(__linux__) || defined(_WIN32)
#define _arch_pc
#endif

#if !(defined(_arch_dreamcast) || defined(_arch_pc))
#error "UNSUPPORTED ARCHITECTURE/PLATFORM"
#endif

#ifndef CRAYON_DEBUG

#define CRAYON_DEBUG 0

#endif

#include <stdint.h> // For the uintX_t types
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Checks if the computer running this code is big endian or not
uint8_t crayon_misc_is_big_endian();

void crayon_misc_endian_correction(uint8_t* buffer, size_t bytes); // UNFINISHED. WIP

void crayon_misc_encode_to_buffer(uint8_t* buffer, uint8_t* data, size_t bytes);

#endif
