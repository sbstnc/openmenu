add_subdirectory(openmenu_settings)
add_subdirectory(openmenu_shared)

# --- Conditional Target Builds ---
if (BUILD_DREAMCAST)
    if (NOT CMAKE_CROSSCOMPILING)
        message(WARNING "BUILD_DREAMCAST is ON but not cross-compiling (CMAKE_CROSSCOMPILING is FALSE). "
                "This target requires a KOS toolchain (e.g., via -DCMAKE_TOOLCHAIN_FILE=...). Skipping OpenMenu build.")
    else ()
        message(STATUS "Configuring OpenMenu for KOS target.")
        # Add the directory containing the openmenu executable target
        add_subdirectory(openmenu)
    endif ()
endif ()

if (BUILD_PC)
    if (CMAKE_CROSSCOMPILING)
        message(WARNING "BUILD_PC is ON but cross-compiling (CMAKE_CROSSCOMPILING is TRUE). "
                "Tools are meant for the host system. Skipping Tools build.")
    else ()
        message(STATUS "Configuring native host tools.")
        # Add the directory containing the tool targets
        add_subdirectory(tools)
    endif ()
endif ()

# --- Sanity Check ---
if (NOT BUILD_DREAMCAST AND NOT BUILD_PC)
    message(WARNING "Both BUILD_DREAMCAST and BUILD_PC are OFF. No main targets will be built.")
endif ()