#include <AetherCircleQuest/AetherCircleQuest.hpp>

#include <android/log.h>
#include <android_native_app_glue.h>
#include <dlfcn.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GLES3/gl3.h>
#include <openxr/openxr.h>
#include <openxr/openxr_platform.h>

#include <android/asset_manager.h>
#include <android/imagedecoder.h>
#include <android/bitmap.h>
#include <map>
#include <array>
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>
#include <cstdint>
#include <cstring>

#include <algorithm>
#include <cmath>
#include <functional>
#include <stdexcept>
#include <cctype>

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
    using Activate = void (*)(std::int32_t);
    using PrepareScene = void (*)();
    using ObjectParent = std::int32_t (*)(std::int32_t);
    using ObjectText = std::int32_t (*)(std::int32_t, char*, std::int32_t);

    void* library = nullptr;
    Start start = nullptr;
    Stop stop = nullptr;
    ObjectCount objectCount = nullptr;
    ObjectPrimitive objectPrimitive = nullptr;
    ObjectValue objectValue = nullptr;
    ObjectColor objectColor = nullptr;
    PrepareScene prepareScene = nullptr;
    ObjectParent objectParent = nullptr;
    ObjectText objectText = nullptr;
    ObjectText objectTexture = nullptr;
    ObjectCount quitRequested = nullptr;
    ObjectCount passthroughRequested = nullptr;
    using SetCapability = void (*)(std::int32_t);
    SetCapability setPassthroughSupported = nullptr;
    ObjectParent objectTarget = nullptr;
    Activate activate = nullptr;

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

        prepareScene = reinterpret_cast<PrepareScene>(dlsym(library, "aethercircle_swift_prepare_scene"));
        objectParent = reinterpret_cast<ObjectParent>(dlsym(library, "aethercircle_swift_object_parent"));
        objectText = reinterpret_cast<ObjectText>(dlsym(library, "aethercircle_swift_object_text"));
        objectTarget = reinterpret_cast<ObjectParent>(dlsym(library, "aethercircle_swift_object_target"));
        activate = reinterpret_cast<Activate>(dlsym(library, "aethercircle_swift_activate"));
        objectTexture = reinterpret_cast<ObjectText>(dlsym(library, "aethercircle_swift_object_texture"));
        quitRequested = reinterpret_cast<ObjectCount>(dlsym(library, "aethercircle_swift_quit_requested"));
        passthroughRequested = reinterpret_cast<ObjectCount>(dlsym(library, "aethercircle_swift_passthrough_requested"));
        setPassthroughSupported = reinterpret_cast<SetCapability>(dlsym(library, "aethercircle_swift_set_passthrough_supported"));
        if (passthroughRequested == nullptr || setPassthroughSupported == nullptr || objectTexture == nullptr || quitRequested == nullptr || objectTarget == nullptr || activate == nullptr || prepareScene == nullptr || objectParent == nullptr || objectText == nullptr || start == nullptr || stop == nullptr || objectCount == nullptr ||
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
        return true;
    }

    void startApplication(bool passthroughSupported) {
        setPassthroughSupported(passthroughSupported ? 1 : 0);
        start();
        __android_log_print(
            ANDROID_LOG_INFO,
            logTag,
            "Shared Swift application started with %d scene object(s).",
            objectCount()
        );
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
    const aethercircle::ApplicationInfo& application,
    bool& passthroughSupported
) {
    std::vector<const char*> extensions{
        XR_KHR_ANDROID_CREATE_INSTANCE_EXTENSION_NAME,
        XR_KHR_OPENGL_ES_ENABLE_EXTENSION_NAME
    };

    uint32_t extensionCount=0;
    xrEnumerateInstanceExtensionProperties(nullptr,0,&extensionCount,nullptr);
    std::vector<XrExtensionProperties> available(extensionCount,{XR_TYPE_EXTENSION_PROPERTIES});
    if(XR_SUCCEEDED(xrEnumerateInstanceExtensionProperties(nullptr,extensionCount,&extensionCount,available.data()))) {
        passthroughSupported=std::any_of(available.begin(),available.end(),[](const auto& extension) {
            return std::strcmp(extension.extensionName,XR_FB_PASSTHROUGH_EXTENSION_NAME)==0;
        });
    }
    if(passthroughSupported)extensions.push_back(XR_FB_PASSTHROUGH_EXTENSION_NAME);

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

#include "QuestRender.hpp"

// Always service NativeActivity lifecycle commands and consume pending input.
void pumpAndroid(android_app* app, int timeout) {
    int events=0;
    android_poll_source* source=nullptr;
    int result=ALooper_pollOnce(timeout,nullptr,&events,reinterpret_cast<void**>(&source));
    while(result>=0) {
        if(source)source->process(app,source);
        if(app->destroyRequested)return;
        result=ALooper_pollOnce(0,nullptr,&events,reinterpret_cast<void**>(&source));
    }
}

} // namespace

namespace aethercircle {
void run(android_app* app, const ApplicationInfo& application) {
    log("AetherCircle Quest GLES runtime started.");
    JNIEnv* env=nullptr;
    const bool attached=app->activity->vm->GetEnv(reinterpret_cast<void**>(&env),JNI_VERSION_1_6)==JNI_EDETACHED;
    if(attached && app->activity->vm->AttachCurrentThread(&env,nullptr)!=JNI_OK) {
        log("Unable to attach native runtime thread to JVM.");
        ANativeActivity_finish(app->activity);
        while(!app->destroyRequested)pumpAndroid(app,100);
        return;
    }
    app->onAppCmd=[](android_app*,int32_t command) {
        __android_log_print(ANDROID_LOG_INFO,logTag,"Android lifecycle command: %d",command);
    };
    app->onInputEvent=[](android_app*,AInputEvent*) -> int32_t { return 1; };
    SwiftBridge swift;
    XrInstance instance=XR_NULL_HANDLE;
    try {
        if(!swift.load(app))throw std::runtime_error("Swift application startup");
        if(!initializeLoader(app))throw std::runtime_error("OpenXR loader initialization");
        bool passthroughSupported=false;
        instance=createInstance(app,application,passthroughSupported);
        if(instance==XR_NULL_HANDLE)throw std::runtime_error("OpenXR instance creation");
        XrSystemGetInfo info{XR_TYPE_SYSTEM_GET_INFO};info.formFactor=XR_FORM_FACTOR_HEAD_MOUNTED_DISPLAY;
        XrSystemId system=XR_NULL_SYSTEM_ID;
        xrCheck(xrGetSystem(instance,&info,&system),"get headset system");
        if(passthroughSupported) {
            XrSystemPassthroughPropertiesFB passthrough{XR_TYPE_SYSTEM_PASSTHROUGH_PROPERTIES_FB};
            XrSystemProperties properties{XR_TYPE_SYSTEM_PROPERTIES};properties.next=&passthrough;
            xrCheck(xrGetSystemProperties(instance,system,&properties),"query passthrough support");
            passthroughSupported=passthrough.supportsPassthrough==XR_TRUE;
        }
        swift.startApplication(passthroughSupported);
        // Scoped cleanup releases session/GL objects before destroying the instance.
        QuestRenderer renderer(swift,app->activity->assetManager);
        renderer.initialize(instance,system,passthroughSupported);
        bool exitSent=false;
        while(!app->destroyRequested && !renderer.exitRequested) {
            pumpAndroid(app,renderer.running?0:100);
            if(app->destroyRequested)break;
            renderer.pollEvents();
            if(swift.quitRequested() && !exitSent) {
                log("Showcase requested native Quit.");
                if(renderer.running)xrCheck(xrRequestExitSession(renderer.session),"request session exit");
                else renderer.exitRequested=true;
                exitSent=true;
            }
            if(renderer.running && !renderer.exitRequested)renderer.frame();
        }
    } catch(const std::exception& error) {
        __android_log_print(ANDROID_LOG_ERROR,logTag,"Quest startup/render failure: %s; EGL error=0x%x",error.what(),eglGetError());
    }
    if(instance)xrDestroyInstance(instance);
    swift.unload();
    if(!app->destroyRequested) {
        ANativeActivity_finish(app->activity);
        while(!app->destroyRequested)pumpAndroid(app,100);
    }
    if(attached)app->activity->vm->DetachCurrentThread();
    log("AetherCircle Quest runtime stopped.");
}
} // namespace aethercircle

