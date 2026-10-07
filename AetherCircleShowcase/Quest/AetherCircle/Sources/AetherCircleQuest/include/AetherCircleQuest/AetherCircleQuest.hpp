#pragma once

#include <cstdint>

struct android_app;

namespace aethercircle {

struct ApplicationInfo {
    const char* name;
    std::uint32_t version;
};

void run(android_app* app, const ApplicationInfo& application);

}  // namespace aethercircle

