add_library(crayon_savefile STATIC
        src/misc.c
        src/peripheral.c
        src/savefile.c
        include/crayon_savefile/misc.h
        include/crayon_savefile/peripheral.h
        include/crayon_savefile/savefile.h
)

target_include_directories(crayon_savefile
        PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
        PRIVATE
        src
)