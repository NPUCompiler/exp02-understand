cmake_minimum_required(VERSION 3.24)

project(testcuda)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CUDA_SEPARABLE_COMPILATION ON)

enable_language(CXX)
enable_language(CUDA)

add_executable(${PROJECT_NAME} main.cpp test.cu test.cuh)
