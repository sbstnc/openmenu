add_executable(metapacker src/metapacker.c src/dat_packer_internal.c)
target_include_directories(metapacker PRIVATE src)
target_link_libraries(metapacker PRIVATE uthash openmenu_shared ini)

add_executable(menufaker src/menufaker.c)
target_include_directories(menufaker PRIVATE src)

add_executable(datpack src/packer.c src/dat_packer_internal.c)
target_include_directories(datpack PRIVATE src)
target_link_libraries(datpack PRIVATE uthash openmenu_shared)

add_executable(datread src/reader.c)
target_include_directories(datread PRIVATE src)
target_link_libraries(datread PRIVATE uthash openmenu_shared)

add_executable(renamecsv src/renamecsv.c)
target_include_directories(renamecsv PRIVATE src)

add_executable(datstrip src/stripper.c)
target_include_directories(datstrip PRIVATE src)
target_link_libraries(datstrip PRIVATE uthash openmenu_shared)

add_executable(tsv2ini src/tsv_to_txt_ini.c)
target_include_directories(tsv2ini PRIVATE src)