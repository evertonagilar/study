cmake_minimum_required(VERSION 3.10)
project(calc C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_FLAGS "-static")

add_executable(calc calc.c)
