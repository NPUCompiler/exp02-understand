cmake_minimum_required(VERSION 3.25)

project(example03 C)

set(CMAKE_C_STANDARD 11)

find_package(OpenMP REQUIRED)

add_executable(test2-1 test2.c)
target_compile_options(test2-1 PRIVATE -O2)

add_executable(test2-2 test2.c)
target_compile_options(test2-2 PRIVATE ${OpenMP_C_FLAGS} -O2)
target_link_libraries(test2-2 PRIVATE OpenMP::OpenMP_C)