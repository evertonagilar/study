cmake_minimum_required(VERSION 3.22)
project(vmproj)
set(CMAKE_C_STANDARD 23)
#add_executable(vmproj vm.c file_utils.c types.h file_utils.h test.c test.h module.h module.c btree.h btree.c program.c program.h)
FIND_PACKAGE(PkgConfig REQUIRED)

PKG_CHECK_MODULES(GLIB REQUIRED glib-2.0)

INCLUDE_DIRECTORIES(
        src/include/
        ${GLIB_INCLUDE_DIRS}
)

LINK_DIRECTORIES(${GLIB_LIBRARY_DIRS})

FILE(GLOB SRC src/*.c)

ADD_EXECUTABLE(${CMAKE_PROJECT_NAME} ${SRC})

TARGET_LINK_LIBRARIES(${CMAKE_PROJECT_NAME} ${GLIB_LIBRARIES})
