#include <AetherCircleQuest/AetherCircleQuest.hpp>

#include <android/log.h>
#include <android_native_app_glue.h>
#include <dlfcn.h>
#include <vulkan/vulkan.h>
#include <openxr/openxr.h>
#include <openxr/openxr_platform.h>

#include <android/asset_manager.h>
#include <array>
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>
#include <cstdint>
#include <cstring>

namespace {

constexpr const char* logTag = "AetherCircleQuest";

void log(const char* text) {
    __android_log_print(ANDROID_LOG_INFO, logTag, "%s", text);
}

// Shared/Files contains flat resource names. Refresh them on each launch.
bool prepareResources(android_app* app, std::string& directory) {
    if (app->activity->internalDataPath == nullptr) { return false; }
    directory = std::string(app->activity->internalDataPath) + "/aethercircle-resources";
    std::error_code error;
    std::filesystem::create_directories(directory, error);
    if (error) { return false; }
    AAssetDir* assets = AAssetManager_openDir(app->activity->assetManager, "aethercircle");
    if (assets == nullptr) { return false; }
    bool success = true;
    while (const char* name = AAssetDir_getNextFileName(assets)) {
        const std::string filename(name);
        if (filename == "." || filename == ".." || filename.find('/') != std::string::npos) {
            success = false;
            break;
        }
        const std::string assetPath = "aethercircle/" + filename;
        AAsset* asset = AAssetManager_open(app->activity->assetManager, assetPath.c_str(), AASSET_MODE_STREAMING);
        if (asset == nullptr) { success = false; break; }
        std::ofstream output(directory + "/" + filename, std::ios::binary | std::ios::trunc);
        std::array<char, 16384> buffer;
        int count = 0;
        while (output && (count = AAsset_read(asset, buffer.data(), buffer.size())) > 0) {
            output.write(buffer.data(), count);
        }
        success = output.good() && count == 0;
        AAsset_close(asset);
        if (!success) { break; }
    }
    AAssetDir_close(assets);
    return success;
}

struct SwiftBridge {
    using SetResourceDirectory = void (*)(const char*);
    using Start = void (*)();
    using Stop = void (*)();
    using ObjectCount = std::int32_t (*)();
    using ObjectPrimitive = std::int32_t (*)(std::int32_t);
    using ObjectValue = float (*)(std::int32_t, std::int32_t);
    using ObjectColor = float (*)(std::int32_t, std::int32_t);

    void* library = nullptr;
    Start start = nullptr;
    Stop stop = nullptr;
    ObjectCount objectCount = nullptr;
    ObjectPrimitive objectPrimitive = nullptr;
    ObjectValue objectValue = nullptr;
    ObjectColor objectColor = nullptr;

    bool load(android_app* app) {
        library = dlopen("libAetherCircleQuestApp.so", RTLD_NOW | RTLD_LOCAL);
        if (library == nullptr) {
            __android_log_print(
                ANDROID_LOG_ERROR,
                logTag,
                "Unable to load shared Swift application: %s",
                dlerror()
            );
            return false;
        }

        start = reinterpret_cast<Start>(
            dlsym(library, "aethercircle_swift_start")
        );
        stop = reinterpret_cast<Stop>(
            dlsym(library, "aethercircle_swift_stop")
        );
        objectCount = reinterpret_cast<ObjectCount>(
            dlsym(library, "aethercircle_swift_object_count")
        );
        objectPrimitive = reinterpret_cast<ObjectPrimitive>(
            dlsym(library, "aethercircle_swift_object_primitive")
        );
        objectValue = reinterpret_cast<ObjectValue>(
            dlsym(library, "aethercircle_swift_object_value")
        );
        objectColor = reinterpret_cast<ObjectColor>(
            dlsym(library, "aethercircle_swift_object_color")
        );

        if (start == nullptr || stop == nullptr || objectCount == nullptr ||
            objectPrimitive == nullptr || objectValue == nullptr ||
            objectColor == nullptr) {
            log("The shared Swift application bridge is incomplete.");
            dlclose(library);
            library = nullptr;
            return false;
        }

        auto setResourceDirectory = reinterpret_cast<SetResourceDirectory>(
            dlsym(library, "aethercircle_swift_set_resource_directory")
        );
        std::string resourceDirectory;
        if (setResourceDirectory == nullptr || !prepareResources(app, resourceDirectory)) {
            log("Unable to prepare shared application resources.");
            dlclose(library);
            library = nullptr;
            return false;
        }
        setResourceDirectory(resourceDirectory.c_str());
        start();
        __android_log_print(
            ANDROID_LOG_INFO,
            logTag,
            "Shared Swift application started with %d scene object(s).",
            objectCount()
        );
        return true;
    }

    void unload() {
        if (library == nullptr) {
            return;
        }
        stop();
        dlclose(library);
        library = nullptr;
    }
};

bool initializeLoader(android_app* app) {
    PFN_xrInitializeLoaderKHR initialize = nullptr;
    const XrResult result = xrGetInstanceProcAddr(
        XR_NULL_HANDLE,
        "xrInitializeLoaderKHR",
        reinterpret_cast<PFN_xrVoidFunction*>(&initialize)
    );
    if (XR_FAILED(result) || initialize == nullptr) {
        return false;
    }

    XrLoaderInitInfoAndroidKHR info{
        XR_TYPE_LOADER_INIT_INFO_ANDROID_KHR
    };
    info.applicationVM = app->activity->vm;
    info.applicationContext = app->activity->clazz;

    return XR_SUCCEEDED(initialize(
        reinterpret_cast<const XrLoaderInitInfoBaseHeaderKHR*>(&info)
    ));
}

XrInstance createInstance(
    android_app* app,
    const aethercircle::ApplicationInfo& application
) {
    const std::array<const char*, 2> extensions{
        XR_KHR_ANDROID_CREATE_INSTANCE_EXTENSION_NAME,
        XR_KHR_VULKAN_ENABLE2_EXTENSION_NAME
    };

    XrInstanceCreateInfoAndroidKHR androidInfo{
        XR_TYPE_INSTANCE_CREATE_INFO_ANDROID_KHR
    };
    androidInfo.applicationVM = app->activity->vm;
    androidInfo.applicationActivity = app->activity->clazz;

    XrInstanceCreateInfo info{XR_TYPE_INSTANCE_CREATE_INFO};
    info.next = &androidInfo;
    std::strncpy(
        info.applicationInfo.applicationName,
        application.name,
        XR_MAX_APPLICATION_NAME_SIZE - 1
    );
    info.applicationInfo.applicationVersion = application.version;
    std::strncpy(
        info.applicationInfo.engineName,
        "AetherCircle",
        XR_MAX_ENGINE_NAME_SIZE - 1
    );
    info.applicationInfo.engineVersion = 1;
    info.applicationInfo.apiVersion = XR_CURRENT_API_VERSION;
    info.enabledExtensionCount =
        static_cast<std::uint32_t>(extensions.size());
    info.enabledExtensionNames = extensions.data();

    XrInstance instance = XR_NULL_HANDLE;
    return XR_SUCCEEDED(xrCreateInstance(&info, &instance))
        ? instance
        : XR_NULL_HANDLE;
}

}  // namespace

namespace aethercircle {

void run(android_app* app, const ApplicationInfo& application) {
    log("AetherCircle Quest runtime started.");

    SwiftBridge swift;
    if (!swift.load(app)) {
        log("Shared Swift application startup failed.");
        return;
    }

    if (!initializeLoader(app)) {
        log("OpenXR loader initialization failed.");
        swift.unload();
        return;
    }

    const XrInstance instance = createInstance(app, application);
    if (instance == XR_NULL_HANDLE) {
        log("OpenXR instance creation failed.");
        swift.unload();
        return;
    }

    XrSystemGetInfo systemInfo{XR_TYPE_SYSTEM_GET_INFO};
    systemInfo.formFactor = XR_FORM_FACTOR_HEAD_MOUNTED_DISPLAY;
    XrSystemId system = XR_NULL_SYSTEM_ID;

    if (XR_FAILED(xrGetSystem(instance, &systemInfo, &system))) {
        log("Quest OpenXR system was not found.");
        xrDestroyInstance(instance);
        swift.unload();
        return;
    }

    log("OpenXR instance and Quest system are ready.");

    while (!app->destroyRequested) {
        int events = 0;
        android_poll_source* source = nullptr;
        while (ALooper_pollOnce(
            10,
            nullptr,
            &events,
            reinterpret_cast<void**>(&source)
        ) >= 0) {
            if (source != nullptr) {
                source->process(app, source);
            }
            if (app->destroyRequested) {
                break;
            }
        }
    }

    xrDestroyInstance(instance);
    swift.unload();
    log("AetherCircle Quest runtime stopped.");
}

}  // namespace aethercircle

