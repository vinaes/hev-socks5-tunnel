#!/bin/bash

# Проверяем наличие ANDROID_HOME
if [ -z "$ANDROID_HOME" ]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    echo "Set ANDROID_HOME to $ANDROID_HOME"
fi

# Находим последнюю установленную версию NDK
NDK_VERSION=$(ls "$ANDROID_HOME/ndk" | sort -V | tail -1)
if [ -z "$NDK_VERSION" ]; then
    echo "Error: NDK not found in $ANDROID_HOME/ndk"
    exit 1
fi

export NDK_ROOT="$ANDROID_HOME/ndk/$NDK_VERSION"
echo "Using NDK from: $NDK_ROOT"

# Устанавливаем путь к проекту
export NDK_PROJECT_PATH="."

# Важно! Указываем путь к Android.mk напрямую
export APP_BUILD_SCRIPT="$NDK_PROJECT_PATH/Android.mk"

echo "Project path: $NDK_PROJECT_PATH"
echo "Build script: $APP_BUILD_SCRIPT"

# Запускаем сборку
echo "Starting build..."
"$NDK_ROOT/ndk-build" APP_BUILD_SCRIPT="$APP_BUILD_SCRIPT"

if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo "Libraries can be found in $NDK_PROJECT_PATH/libs/"
else
    echo "Build failed!"
    exit 1
fi
