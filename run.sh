#!/bin/bash
set -e

DERIVED_DATA="$(pwd)/DerivedData"
APP_NAME="ComfyEditor.app"
SCHEME="ComfyEditor_JUST_EDITOR"

xcodebuild \
    -scheme "$SCHEME" \
    -derivedDataPath "$DERIVED_DATA" \
    build


APP_PATH=$(find "$DERIVED_DATA/Build/Products" -type d -name "$APP_NAME" -maxdepth 3 | head -n 1)

if [ -z "$APP_PATH" ]; then
  echo "❌ App not found"
  exit 1
fi

rm -rf $APP_NAME

mv "$APP_PATH" ./
rm -rf $DERIVED_DATA

echo "✅ Built and moved $APP_NAME"
open $APP_NAME
