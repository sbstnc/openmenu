#ifndef OPENMENU_SAVEFILE_H
#define OPENMENU_SAVEFILE_H

#include <crayon_savefile/savefile.h>

void savefile_defaults();

uint8_t setup_savefile(crayon_savefile_details_t* details);

int8_t update_savefile(void** loaded_variables, crayon_savefile_version_t loaded_version,
                       crayon_savefile_version_t latest_version);

int8_t find_first_valid_savefile_device(crayon_savefile_details_t* details);
void savefile_init();
void savefile_close();
int8_t savefile_save();

#endif //OPENMENU_SAVEFILE_H
