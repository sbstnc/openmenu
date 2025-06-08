set(OPENMENUSHARED_COMMON_SOURCES
        src/backend/gd_list.c
        src/texture/dat_reader.c
)
set(OPENMENUSHARED_COMMON_HEADERS
        include/dbgprint.h
        include/backend/dat_format.h
        include/backend/db_item.def
        include/backend/db_item.h
        include/backend/gd_item.def
        include/backend/gd_item.h
        include/backend/gd_list.h
)

set(OPENMENUSHARED_DREAMCAST_SOURCES "")
set(OPENMENUSHARED_DREAMCAST_HEADERS "")
if (BUILD_DREAMCAST)
    list(APPEND OPENMENUSHARED_DREAMCAST_SOURCES
            src/backend/db_list.c
            src/texture/serial_sanitize.c
    )
    list(APPEND OPENMENUSHARED_DREAMCAST_HEADERS
            include/backend/db_list.h
            include/texture/serial_sanitize.h
    )
endif ()

add_library(openmenu_shared STATIC ${OPENMENUSHARED_COMMON_SOURCES} ${OPENMENUSHARED_DREAMCAST_SOURCES})
target_sources(openmenu_shared PUBLIC ${OPENMENUSHARED_COMMON_HEADERS} ${OPENMENUSHARED_DREAMCAST_HEADERS})

target_include_directories(openmenu_shared
        PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
        PRIVATE
        src
)

target_link_libraries(openmenu_shared PRIVATE ini uthash)
if (BUILD_DREAMCAST)
    target_link_libraries(openmenu_shared PRIVATE openmenu_settings crayon_savefile)
endif ()