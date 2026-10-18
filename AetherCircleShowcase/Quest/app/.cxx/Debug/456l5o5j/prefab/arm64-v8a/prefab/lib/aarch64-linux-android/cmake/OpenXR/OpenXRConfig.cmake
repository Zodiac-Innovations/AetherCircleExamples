if(NOT TARGET OpenXR::headers)
add_library(OpenXR::headers INTERFACE IMPORTED)
set_target_properties(OpenXR::headers PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "/Users/steve/.gradle/caches/9.5.0/transforms/640c23ae8c2436172ab537ced7a0c61e/transformed/openxr_loader_for_android-1.1.63/prefab/modules/headers/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET OpenXR::openxr_loader)
add_library(OpenXR::openxr_loader SHARED IMPORTED)
set_target_properties(OpenXR::openxr_loader PROPERTIES
    IMPORTED_LOCATION "/Users/steve/.gradle/caches/9.5.0/transforms/640c23ae8c2436172ab537ced7a0c61e/transformed/openxr_loader_for_android-1.1.63/prefab/modules/openxr_loader/libs/android.arm64-v8a/libopenxr_loader.so"
    INTERFACE_LINK_LIBRARIES "OpenXR::headers"
)
endif()

