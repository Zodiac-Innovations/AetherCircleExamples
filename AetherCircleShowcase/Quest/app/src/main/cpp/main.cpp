#include <AetherCircleQuest/AetherCircleQuest.hpp>
#include <android_native_app_glue.h>

void android_main(android_app* app) {
    app_dummy();

    const aethercircle::ApplicationInfo application{
        "AetherCircle Showcase",
        1
    };
    aethercircle::run(app, application);
}

