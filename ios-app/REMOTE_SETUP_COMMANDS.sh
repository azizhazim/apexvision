#!/bin/bash

################################################################################
# ApexVision AI - Complete Remote Setup Script
# This script does EVERYTHING automatically on the Cloud Mac
# Just copy and paste this entire file into Terminal on Cloud Mac
################################################################################

set -e

echo "🚀 Starting ApexVision AI iOS App Setup..."
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

################################################################################
# Step 1: Navigate to Desktop
################################################################################

echo -e "${BLUE}📁 Setting up workspace...${NC}"
cd ~/Desktop

################################################################################
# Step 2: Check if Xcode is installed
################################################################################

echo -e "${BLUE}🔍 Checking Xcode installation...${NC}"
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode not found. Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "⚠️  Please wait for Xcode installation to complete, then run this script again."
    exit 1
fi
echo -e "${GREEN}✅ Xcode is installed${NC}"

################################################################################
# Step 3: Accept Xcode License
################################################################################

echo -e "${BLUE}📄 Accepting Xcode license...${NC}"
sudo xcodebuild -license accept 2>/dev/null || true
echo -e "${GREEN}✅ License accepted${NC}"

################################################################################
# Step 4: Install CocoaPods
################################################################################

echo -e "${BLUE}💎 Checking CocoaPods...${NC}"
if ! command -v pod &> /dev/null; then
    echo "Installing CocoaPods..."
    sudo gem install cocoapods
fi
echo -e "${GREEN}✅ CocoaPods ready${NC}"

################################################################################
# Step 5: Navigate to project (assumes files are already transferred)
################################################################################

echo -e "${BLUE}📂 Looking for project files...${NC}"

# Check multiple possible locations
if [ -d "~/Desktop/ios-app" ]; then
    cd ~/Desktop/ios-app
elif [ -d "~/Desktop/ApexVision-AI-ChromeExtension/ios-app" ]; then
    cd ~/Desktop/ApexVision-AI-ChromeExtension/ios-app
elif [ -d "~/Downloads/ios-app" ]; then
    cd ~/Downloads/ios-app
else
    echo "❌ Project files not found!"
    echo "Please make sure ios-app folder is on Desktop or in Downloads"
    exit 1
fi

echo -e "${GREEN}✅ Found project at: $(pwd)${NC}"

################################################################################
# Step 6: Install Dependencies
################################################################################

echo -e "${BLUE}📦 Installing dependencies...${NC}"
pod install
echo -e "${GREEN}✅ Dependencies installed${NC}"

################################################################################
# Step 7: Build the app
################################################################################

echo -e "${BLUE}🔨 Building app...${NC}"

xcodebuild \
    -workspace ApexVisionAI.xcworkspace \
    -scheme ApexVisionAI \
    -sdk iphonesimulator \
    -configuration Debug \
    -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
    clean build

echo -e "${GREEN}✅ Build completed!${NC}"

################################################################################
# Step 8: Open in Xcode
################################################################################

echo -e "${BLUE}🎯 Opening Xcode...${NC}"
open ApexVisionAI.xcworkspace

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ SETUP COMPLETE!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Next steps:"
echo "1. Xcode should now be open"
echo "2. Press Cmd + R to run on simulator"
echo "3. Test the app"
echo "4. Create archive: Product > Archive"
echo ""
echo "🎉 Your iOS app is ready!"

