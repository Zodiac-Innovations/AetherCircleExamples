# AetherCircle Showcase — Quest

Generated using AetherCircleDevelopment/QuestSupport and the expanded development Core copied unchanged. Shared/Swift and Shared/Files remain the application source of truth and are refreshed by build-swift.sh on every build.

Build on your configured Mac:

```bash
cd AetherCircleShowcase/Quest
./gradlew :app:assembleDebug
```

The ARM64 APK is app/build/outputs/apk/debug/app-debug.apk. Requires Swift 6.3 with its matching Swift SDK for Android, JDK 17+, Android SDK 36, NDK 29.0.14206865, and CMake 3.31.6. Set ANDROID_HOME or an untracked local.properties if the SDK is not discovered.

This step updates the Swift adapter and resource packaging. The native runtime initializes OpenXR but does not render yet. Controller input, text/mesh rendering, passthrough, and native Quit remain subsequent work.

Do not regenerate with the old CLI's quest create -d: its public template uses an older Core. Preserve this Quest directory before regenerating with the dedicated development script.
