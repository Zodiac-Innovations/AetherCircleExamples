# AetherCircle Showcase — Quest

Generated using AetherCircleDevelopment/QuestSupport and the expanded development Core copied unchanged. Shared/Swift and Shared/Files remain the application source of truth and are refreshed by build-swift.sh on every build.

Build on your configured Mac:

```bash
cd AetherCircleShowcase/Quest
./gradlew :app:assembleDebug
```

The ARM64 APK is app/build/outputs/apk/debug/app-debug.apk. Requires Swift 6.3 with its matching Swift SDK for Android, JDK 17+, Android SDK 36, NDK 29.0.14206865, and CMake 3.31.6. Set ANDROID_HOME or an untracked local.properties if the SDK is not discovered.

This step updates the Swift adapter and resource packaging. Home rendering is implemented; controller input, additional primitive meshes, passthrough, and native Quit remain subsequent work.

Do not regenerate with the old CLI's quest create -d: its public template uses an older Core. Preserve this Quest directory before regenerating with the dedicated development script.

## Step 4: Home rendering

The native runtime now uses OpenXR with OpenGL ES 3, two eye swapchains,
head-tracked projection views, depth testing, and a dark full-VR background.
STAGE space preserves floor-relative sample coordinates; LOCAL fallback assumes
an eye height of 1.6 m. The bridge snapshots visible composite children and
provides local transforms, rotation rates, resolved colors, and text.

Home displays its title, three scene button backgrounds/labels, and rotating
Quit button. The compact 5x7 font draws uppercase forms. This pass renders box
geometry and text only: other primitives, textures, transitions, controller
interaction, native Quit, and passthrough remain subsequent steps. Showcase's
passthrough request currently renders against the full-VR background.

Look for `OpenXR GLES session, floor space and stereo swapchains are ready.`
and `First stereo Showcase frame submitted.` in AetherCircleQuest logs.
Startup failures now request activity shutdown while pumping lifecycle events.

Validation: Android ARM64 native compilation with NDK r29/OpenXR 1.1.63 headers;
parent-transform, inverse-pose, near/far projection checks; manifest XML parsing.
Full APK compilation and visual verification must run on the configured Mac/headset.

## Quit, meshes and materials

Quit confirmation now calls the Quest platform quit service, requests OpenXR
session exit, releases graphics/session resources, and finishes NativeActivity.
All 18 visible primitive cases now have procedural meshes. Base-color PNG/JPG
textures are decoded using Android ImageDecoder and uploaded with mipmaps;
roughness and metallic values influence basic lighting (not full PBR parity).
Other material texture channels are not implemented yet.

Build and verify assets/runtime packaging with:

```bash
./gradlew :app:verifyQuestApk --console=plain
```

The verifier compares all Shared/Files bytes with their APK assets and checks
required ARM64 runtime libraries. The renderer logs each texture filename as
loaded or FAILED. Controller mesh hit testing currently covers box geometry.

### Name in Meta system overlays

Application and NativeActivity labels explicitly use app_name. Horizon OS may
still display 'App name unavailable' for an unregistered/sideloaded application.
A real Meta Developer app registration and its numeric App ID may be needed for
the overlay title. Once that ID is known, add com.oculus.app_id application
metadata using the real ID; do not insert a dummy ID. This does not prevent
in-app Quit or local rendering.
