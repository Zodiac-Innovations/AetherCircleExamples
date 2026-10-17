#!/bin/bash

set -euo pipefail

QUEST_ROOT="$(cd "$(dirname "$0")" && pwd)"
PACKAGE_ROOT="$QUEST_ROOT/SwiftPackage"
SHARED_SOURCE="$QUEST_ROOT/../Shared/Swift"
SHARED_DESTINATION="$PACKAGE_ROOT/Sources/QuestApplication/Shared"
JNI_LIBS="$QUEST_ROOT/app/src/main/jniLibs/arm64-v8a"
SCRATCH_PATH="$PACKAGE_ROOT/.build-aethercircle-android-aarch64"

if [ ! -d "$SHARED_SOURCE" ]; then
    echo "Error: Shared/Swift was not found at $SHARED_SOURCE" >&2
    exit 1
fi

SWIFT_ANDROID_SDK="${AETHERCIRCLE_SWIFT_ANDROID_SDK:-}"
if [ -z "$SWIFT_ANDROID_SDK" ]; then
    SWIFT_ANDROID_SDK="$(
        swift sdk list |
            awk 'tolower($0) ~ /android/ { print $1; exit }'
    )"
fi

if [ -z "$SWIFT_ANDROID_SDK" ]; then
    echo "Error: Swift SDK for Android was not found." >&2
    echo "Install it with 'swift sdk install' or set AETHERCIRCLE_SWIFT_ANDROID_SDK." >&2
    exit 1
fi

SWIFT_RESOURCE_DIR="${AETHERCIRCLE_SWIFT_ANDROID_RESOURCE_DIR:-}"
if [ -z "$SWIFT_RESOURCE_DIR" ]; then
    SWIFT_RUNTIME_DIR="$(
        find "$HOME/Library/org.swift.swiftpm/swift-sdks"             -type d             -path "*/swift-android/swift-resources/usr/lib/swift-aarch64/android"             -print             -quit
    )"
    if [ -n "$SWIFT_RUNTIME_DIR" ]; then
        SWIFT_RESOURCE_DIR="$(dirname "$SWIFT_RUNTIME_DIR")"
    fi
fi

if [ ! -d "$SWIFT_RESOURCE_DIR/android" ]; then
    echo "Error: The aarch64 Swift Android runtime was not found." >&2
    echo "Set AETHERCIRCLE_SWIFT_ANDROID_RESOURCE_DIR to its swift-aarch64 directory." >&2
    exit 1
fi

rm -rf "$SHARED_DESTINATION"
mkdir -p "$SHARED_DESTINATION"
cp -R "$SHARED_SOURCE/." "$SHARED_DESTINATION/"

SHARED_FILES="$QUEST_ROOT/../Shared/Files"
ASSET_DESTINATION="$QUEST_ROOT/app/src/main/assets/aethercircle"
if [ ! -d "$SHARED_FILES" ]; then
    echo "Error: Shared/Files was not found." >&2
    exit 1
fi
rm -rf "$ASSET_DESTINATION"
mkdir -p "$ASSET_DESTINATION"
cp -R "$SHARED_FILES/." "$ASSET_DESTINATION/"

SWIFT_ANDROID_TRIPLE="${AETHERCIRCLE_SWIFT_ANDROID_TRIPLE:-aarch64-unknown-linux-android32}"

swift build     --package-path "$PACKAGE_ROOT"     --scratch-path "$SCRATCH_PATH"     --swift-sdk "$SWIFT_ANDROID_SDK"     --triple "$SWIFT_ANDROID_TRIPLE"     --configuration debug     -Xswiftc -resource-dir     -Xswiftc "$SWIFT_RESOURCE_DIR"

LIBRARY="$(
    find "$SCRATCH_PATH"         -type f         -name "libAetherCircleQuestApp.so"         -print         -quit
)"
if [ -z "$LIBRARY" ] || [ ! -f "$LIBRARY" ]; then
    echo "Error: The Swift Quest application library was not produced." >&2
    exit 1
fi

mkdir -p "$JNI_LIBS"
cp "$LIBRARY" "$JNI_LIBS/"

RUNTIME_COUNT=0
while IFS= read -r runtime_library; do
    cp "$runtime_library" "$JNI_LIBS/"
    RUNTIME_COUNT=$((RUNTIME_COUNT + 1))
done < <(
    find -L "$SWIFT_RESOURCE_DIR/android" -maxdepth 1 -type f -name '*.so' -print
)

if [ "$RUNTIME_COUNT" -eq 0 ]; then
    echo "Error: No aarch64 Swift Android runtime libraries were found." >&2
    exit 1
fi

printf '\033[0;32mBuilt the shared Swift Quest application.\033[0m\n'

