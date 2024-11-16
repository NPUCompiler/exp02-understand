cmake_minimum_required(VERSION 3.25)

project(example02 C)

set(CMAKE_C_STANDARD 11)

add_executable(test1-1 test1.c)

add_executable(test1-2 test1.c)
target_compile_options(test1-2 PRIVATE -O2)
