cmake_minimum_required(VERSION 3.10)
project(c_interpreter)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_C_STANDARD 14)
set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_BUILD_TYPE DEBUG)
set(CMAKE_C_FLAGS "-O0 -ggdb")
set(CMAKE_C_FLAGS_DEBUG "-O0 -ggdb")
set(CMAKE_C_FLAGS_RELEASE "-O0 -ggdb")
set(CMAKE_CXX_FLAGS "-O0 -ggdb")
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "-O0 -ggdb")

include_directories(.)

add_executable(c_interpreter
        ci.c
        ci_bstree.h
        ci_bstree.c)
