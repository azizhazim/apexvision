#!/bin/bash

# ApexVision AI iOS App Setup Script
# This script sets up the development environment for the iOS app

echo "🚀 Setting up ApexVision AI iOS App..."

# Check if CocoaPods is installed
if ! command -v pod &> /dev/null; then
    echo "❌ CocoaPods not found. Installing..."
    sudo gem install cocoapods
else
    echo "✅ CocoaPods is installed"
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode not found. Please install Xcode from the App Store."
    exit 1
else
    echo "✅ Xcode is installed"
fi

# Install dependencies
echo "📦 Installing dependencies..."
cd "$(dirname "$0")"
pod install

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed successfully"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi

# Check for GoogleService-Info.plist
if [ ! -f "ApexVisionAI/ApexVisionAI/GoogleService-Info.plist" ]; then
    echo "⚠️  Warning: GoogleService-Info.plist not found"
    echo "   Please download it from Firebase Console and add it to the project"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Open ApexVisionAI.xcworkspace (NOT .xcodeproj)"
echo "2. Add your GoogleService-Info.plist from Firebase Console"
echo "3. Update the API_KEY in GoogleService-Info.plist"
echo "4. Select your development team in Xcode"
echo "5. Build and run (Cmd + R)"
echo ""
echo "To open the workspace:"
echo "  open ApexVisionAI.xcworkspace"

