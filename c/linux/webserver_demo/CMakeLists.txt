cmake_minimum_required(VERSION 3.24)
project(webserver_demo)

set(CMAKE_CXX_STANDARD 23)

add_executable(webserver_demo main.cpp tarefa.h fila_circular.h fila_circular.cpp WebServerException.h tarefa.cpp)
