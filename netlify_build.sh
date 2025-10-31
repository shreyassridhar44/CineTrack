#!/usr/bin/env bash
# This script tells the build process to exit immediately if any command fails.
set -e

# --- 1. INSTALL FLUTTER SDK ---
echo "Cloning Flutter repository..."
git clone https://github.com/flutter/flutter.git --depth 1 --branch stable $HOME/flutter
export PATH="$HOME/flutter/bin:$PATH"

# --- 2. SETUP FLUTTER PROJECT ---
echo "Configuring Flutter and getting dependencies..."
flutter config --enable-web
flutter pub get

# --- 3. BUILD THE FLUTTER WEB APP ---
echo "Building Flutter web..."
flutter build web --release

echo "Build finished successfully!"