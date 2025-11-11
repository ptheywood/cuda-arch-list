cmake_minimum_required(VERSION 3.25.2...4.1.1 FATAL_ERROR)

project(cuda_arch_list LANGUAGES CUDA)

set(SRC "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cu")

add_executable(${PROJECT_NAME} ${SRC})

# set c++20, not required but implicitly means CUDA >= 12
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_20)
target_compile_features(${PROJECT_NAME} PUBLIC cuda_std_20)
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_EXTENSIONS OFF)
set_property(TARGET ${PROJECT_NAME} PROPERTY CUDA_EXTENSIONS OFF)
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD_REQUIRED ON)
set_property(TARGET ${PROJECT_NAME} PROPERTY CUDA_STANDARD_REQUIRED ON)