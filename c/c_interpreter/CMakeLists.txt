cmake_minimum_required(VERSION 3.10)
project(c_interpreter)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

add_executable(c_interpreter
        ci.c
        ci_bstree.h
        ci_bstree.c)
