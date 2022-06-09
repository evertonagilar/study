cmake_minimum_required(VERSION 3.22)
project(vmproj)

set(CMAKE_C_STANDARD 23)

add_executable(vmproj vm.c utils.c types.h utils.h test.c test.h module.h module.c btree.h btree.c)
