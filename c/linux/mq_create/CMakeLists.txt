cmake_minimum_required(VERSION 3.24)
project(mq_create C)

set(CMAKE_C_STANDARD 23)

add_executable(mq_create main.c tlpi_hdr.h get_num.h error_functions.c get_num.c)
