cmake_minimum_required(VERSION 3.15)
project(minidb C)

set(CMAKE_C_STANDARD 99)

add_executable(minidb main.c database.h database.c utils.h utils.c)