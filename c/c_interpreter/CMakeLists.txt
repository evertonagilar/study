cmake_minimum_required(VERSION 3.10)
project(c_interpreter C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_BUILD_TYPE Debug)

add_executable(ci
        ci.c)
