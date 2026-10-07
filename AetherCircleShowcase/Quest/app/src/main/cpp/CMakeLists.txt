cmake_minimum_required(VERSION 3.31.6)
project(AetherCircleShowcaseQuest LANGUAGES C CXX)

find_package(OpenXR REQUIRED CONFIG)

set(AETHERCIRCLE_QUEST_ROOT
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../AetherCircle/Sources/AetherCircleQuest"
)

add_library(android_native_app_glue STATIC
    ${ANDROID_NDK}/sources/android/native_app_glue/android_native_app_glue.c
)
target_include_directories(android_native_app_glue PUBLIC
    ${ANDROID_NDK}/sources/android/native_app_glue
)

add_library(aethercircle_quest STATIC
    ${AETHERCIRCLE_QUEST_ROOT}/AetherCircleQuest.cpp
)
target_include_directories(aethercircle_quest PUBLIC
    ${AETHERCIRCLE_QUEST_ROOT}/include
)
target_compile_features(aethercircle_quest PUBLIC cxx_std_20)
target_compile_definitions(aethercircle_quest PUBLIC
    XR_USE_PLATFORM_ANDROID
    XR_USE_GRAPHICS_API_VULKAN
)
target_link_libraries(aethercircle_quest PUBLIC
    android
    android_native_app_glue
    dl
    log
    OpenXR::openxr_loader
    vulkan
)

add_library(AetherCircleShowcaseQuest SHARED main.cpp)
target_compile_features(AetherCircleShowcaseQuest PRIVATE cxx_std_20)
target_link_libraries(AetherCircleShowcaseQuest PRIVATE
    aethercircle_quest
    android_native_app_glue
)

