#!/bin/bash

# Set environment
export LANG=en_US.UTF-8
eval "$(/opt/homebrew/bin/brew shellenv)"

# Navigate to project directory
cd ~/apexvision/ios-app/ApexVisionAI

echo "========================================="
echo "Building ApexVision AI iOS App"
echo "========================================="

# Build for simulator
echo ""
echo "Step 1: Building for iOS Simulator..."
xcodebuild -workspace ApexVisionAI.xcworkspace \
  -scheme ApexVisionAI \
  -sdk iphonesimulator \
  -configuration Debug \
  -arch x86_64 \
  -arch arm64 \
  build \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  ONLY_ACTIVE_ARCH=NO

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ Simulator build SUCCESSFUL!"
  echo ""
  echo "Step 2: Building for iOS Device (Archive)..."
  
  # Build archive for device
  xcodebuild archive \
    -workspace ApexVisionAI.xcworkspace \
    -scheme ApexVisionAI \
    -sdk iphoneos \
    -configuration Release \
    -archivePath ~/ApexVisionAI.xcarchive \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO
  
  if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Archive build SUCCESSFUL!"
    echo ""
    echo "========================================="
    echo "BUILD COMPLETE!"
    echo "========================================="
    echo ""
    echo "Archive location: ~/ApexVisionAI.xcarchive"
    echo ""
  else
    echo ""
    echo "❌ Archive build FAILED"
    echo "But simulator build succeeded, so the app code is valid!"
  fi
else
  echo ""
  echo "❌ Simulator build FAILED"
  echo "Check the errors above"
fi

