#!/bin/bash

# ApexVision AI iOS App Build Script
# This script builds the iOS app for testing or release

set -e

echo "🔨 Building ApexVision AI iOS App..."

# Configuration
WORKSPACE="ApexVisionAI.xcworkspace"
SCHEME="ApexVisionAI"
CONFIGURATION="Release"
BUILD_DIR="build"

# Parse arguments
BUILD_TYPE="simulator"
CLEAN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --device)
            BUILD_TYPE="device"
            shift
            ;;
        --simulator)
            BUILD_TYPE="simulator"
            shift
            ;;
        --clean)
            CLEAN=true
            shift
            ;;
        --debug)
            CONFIGURATION="Debug"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: ./build.sh [--device|--simulator] [--clean] [--debug]"
            exit 1
            ;;
    esac
done

# Clean if requested
if [ "$CLEAN" = true ]; then
    echo "🧹 Cleaning build directory..."
    rm -rf "$BUILD_DIR"
    xcodebuild clean -workspace "$WORKSPACE" -scheme "$SCHEME" -configuration "$CONFIGURATION"
fi

# Build for simulator or device
if [ "$BUILD_TYPE" = "simulator" ]; then
    echo "📱 Building for iOS Simulator..."
    DESTINATION="platform=iOS Simulator,name=iPhone 15 Pro,OS=latest"
else
    echo "📱 Building for iOS Device..."
    DESTINATION="generic/platform=iOS"
fi

echo "Configuration: $CONFIGURATION"
echo "Destination: $DESTINATION"
echo ""

# Build
xcodebuild \
    -workspace "$WORKSPACE" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -destination "$DESTINATION" \
    -derivedDataPath "$BUILD_DIR" \
    build

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    
    if [ "$BUILD_TYPE" = "device" ]; then
        echo "📦 App built for device"
        echo "Location: $BUILD_DIR/Build/Products/$CONFIGURATION-iphoneos/ApexVisionAI.app"
    else
        echo "📦 App built for simulator"
        echo "Location: $BUILD_DIR/Build/Products/$CONFIGURATION-iphonesimulator/ApexVisionAI.app"
    fi
else
    echo ""
    echo "❌ Build failed"
    exit 1
fi

