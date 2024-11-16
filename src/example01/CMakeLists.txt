cmake_minimum_required(VERSION 3.25)

project(example01 C)

set(CMAKE_C_STANDARD 11)

add_executable(example01 main.c add.c add.h)
