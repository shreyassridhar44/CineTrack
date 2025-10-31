#!/usr/bin/env bash
# This script tells the build process to exit immediately if any command fails.
set -e

# --- 1. CREATE THE .env FILE FROM NETLIFY'S ENVIRONMENT VARIABLE ---
echo "Creating .env file..."
echo "TMDB_API_KEY=${TMDB_API_KEY}" > .env
echo ".env file created successfully."

# --- 2. INSTALL FLUTTER SDK ---
echo "Cloning Flutter repository..."
git clone https://github.com/flutter/flutter.git --depth 1 --branch stable $HOME/flutter
export PATH="$HOME/flutter/bin:$PATH"

# --- 3. SETUP FLUTTER PROJECT ---
echo "Configuring Flutter and getting dependencies..."
flutter config --enable-web
flutter pub get

# --- 4. BUILD THE FLUTTER WEB APP ---
echo "Building Flutter web..."
flutter build web --release

echo "Build finished successfully!"