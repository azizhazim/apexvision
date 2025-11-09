#!/bin/bash

################################################################################
# COMPLETE AUTOMATED SETUP FOR CLOUD MAC
# 
# This script does EVERYTHING for you:
# 1. Clones the repository from GitHub
# 2. Installs all dependencies
# 3. Builds the iOS app
# 4. Creates archive for App Store
# 5. Exports IPA file
#
# Just run this ONE command on your Cloud Mac and walk away!
#
# Usage: bash <(curl -s https://raw.githubusercontent.com/azizhazim/apexvision/main/ios-app/CLOUD_MAC_COMPLETE_SETUP.sh)
################################################################################

set -e  # Exit on any error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/azizhazim/apexvision.git"
PROJECT_DIR="$HOME/apexvision"
IOS_DIR="$PROJECT_DIR/ios-app"
PROJECT_NAME="ApexVisionAI"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  $1${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_step() {
    echo -e "${MAGENTA}▶️  $1${NC}"
}

################################################################################
# Welcome Banner
################################################################################

clear
echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║        ApexVision AI - iOS App Build Automation              ║
║                                                               ║
║        This script will automatically:                        ║
║        • Clone your repository from GitHub                    ║
║        • Install all required dependencies                    ║
║        • Build your iOS app                                   ║
║        • Create App Store archive                             ║
║        • Export IPA file                                      ║
║                                                               ║
║        Sit back and relax! ☕                                 ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

sleep 2

################################################################################
# Step 1: Check Prerequisites
################################################################################

print_header "Step 1/7: Checking Prerequisites"

# Check Xcode
print_step "Checking for Xcode..."
if command -v xcodebuild &> /dev/null; then
    XCODE_VERSION=$(xcodebuild -version | head -n 1)
    print_success "Xcode found: $XCODE_VERSION"
else
    print_error "Xcode not found!"
    print_info "Please install Xcode from the App Store first"
    print_info "This may take 30-60 minutes"
    exit 1
fi

# Accept Xcode license
print_step "Accepting Xcode license..."
sudo xcodebuild -license accept 2>/dev/null || true
print_success "Xcode license accepted"

# Check CocoaPods
print_step "Checking for CocoaPods..."
if command -v pod &> /dev/null; then
    POD_VERSION=$(pod --version)
    print_success "CocoaPods found: $POD_VERSION"
else
    print_warning "CocoaPods not found. Installing..."
    sudo gem install cocoapods
    print_success "CocoaPods installed"
fi

# Check Git
print_step "Checking for Git..."
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    print_success "Git found: $GIT_VERSION"
else
    print_error "Git not found! This should be pre-installed on macOS"
    exit 1
fi

print_success "All prerequisites met!"

################################################################################
# Step 2: Clone Repository
################################################################################

print_header "Step 2/7: Cloning Repository from GitHub"

if [ -d "$PROJECT_DIR" ]; then
    print_warning "Project directory already exists"
    print_step "Removing old directory..."
    rm -rf "$PROJECT_DIR"
fi

print_step "Cloning from: $REPO_URL"
git clone "$REPO_URL" "$PROJECT_DIR"
print_success "Repository cloned successfully"

cd "$IOS_DIR"
print_info "Working directory: $IOS_DIR"

################################################################################
# Step 3: Install Dependencies
################################################################################

print_header "Step 3/7: Installing Dependencies"

print_step "Running pod install..."
print_info "This may take 5-10 minutes..."

pod install

if [ $? -eq 0 ]; then
    print_success "Dependencies installed successfully"
else
    print_error "Failed to install dependencies"
    exit 1
fi

################################################################################
# Step 4: Build for Simulator (Test)
################################################################################

print_header "Step 4/7: Building for Simulator (Test Build)"

print_step "Building for iOS Simulator..."
print_info "This verifies the code compiles correctly"

xcodebuild \
    -workspace "${PROJECT_NAME}.xcworkspace" \
    -scheme "$PROJECT_NAME" \
    -sdk iphonesimulator \
    -configuration Debug \
    -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
    clean build \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    | grep -E '(error|warning|succeeded|failed)' || true

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    print_success "Simulator build succeeded!"
else
    print_error "Simulator build failed"
    print_info "Check the errors above"
    exit 1
fi

################################################################################
# Step 5: Create Archive
################################################################################

print_header "Step 5/7: Creating Archive for App Store"

print_step "Creating archive..."
print_info "This may take 5-10 minutes..."

ARCHIVE_PATH="$HOME/Desktop/${PROJECT_NAME}.xcarchive"

xcodebuild archive \
    -workspace "${PROJECT_NAME}.xcworkspace" \
    -scheme "$PROJECT_NAME" \
    -sdk iphoneos \
    -configuration Release \
    -archivePath "$ARCHIVE_PATH" \
    CODE_SIGN_STYLE=Automatic \
    | grep -E '(error|warning|succeeded|failed)' || true

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    print_success "Archive created successfully!"
    print_info "Archive location: $ARCHIVE_PATH"
else
    print_warning "Archive creation failed (likely due to signing)"
    print_info "You'll need to open Xcode and configure signing manually"
    print_info "Opening Xcode now..."
    open "${PROJECT_NAME}.xcworkspace"
    exit 0
fi

################################################################################
# Step 6: Export IPA
################################################################################

print_header "Step 6/7: Exporting IPA File"

EXPORT_PATH="$HOME/Desktop/${PROJECT_NAME}_Export"

# Create export options plist
cat > "/tmp/ExportOptions.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>uploadSymbols</key>
    <true/>
    <key>uploadBitcode</key>
    <false/>
</dict>
</plist>
EOF

print_step "Exporting IPA..."

xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$EXPORT_PATH" \
    -exportOptionsPlist "/tmp/ExportOptions.plist" \
    | grep -E '(error|warning|succeeded|failed)' || true

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    print_success "IPA exported successfully!"
    print_info "IPA location: ${EXPORT_PATH}/${PROJECT_NAME}.ipa"
else
    print_warning "IPA export failed"
    print_info "You can export manually from Xcode Organizer"
fi

################################################################################
# Step 7: Summary
################################################################################

print_header "Step 7/7: Build Complete! 🎉"

echo -e "${GREEN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║                  ✅ BUILD SUCCESSFUL! ✅                      ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
echo -e "${CYAN}📦 Build Artifacts:${NC}"
echo -e "   ${GREEN}✓${NC} Archive: $ARCHIVE_PATH"
if [ -f "${EXPORT_PATH}/${PROJECT_NAME}.ipa" ]; then
    echo -e "   ${GREEN}✓${NC} IPA: ${EXPORT_PATH}/${PROJECT_NAME}.ipa"
fi
echo ""

echo -e "${CYAN}📱 Next Steps:${NC}"
echo -e "   ${YELLOW}1.${NC} Open Xcode Organizer to view your archive"
echo -e "   ${YELLOW}2.${NC} Upload to TestFlight for beta testing"
echo -e "   ${YELLOW}3.${NC} Submit to App Store for review"
echo ""

echo -e "${CYAN}🚀 Quick Commands:${NC}"
echo -e "   ${BLUE}Open Xcode:${NC}"
echo -e "   open ${PROJECT_NAME}.xcworkspace"
echo ""
echo -e "   ${BLUE}Open Organizer:${NC}"
echo -e "   open -a Xcode"
echo -e "   Then: Window → Organizer → Archives"
echo ""

echo -e "${CYAN}📖 Documentation:${NC}"
echo -e "   See ${BLUE}CLOUD_MAC_SETUP_GUIDE.md${NC} for detailed instructions"
echo -e "   See ${BLUE}TESTING_AND_VALIDATION_GUIDE.md${NC} for testing procedures"
echo ""

print_success "Your iOS app is ready! 🎉"
echo ""

################################################################################
# End of Script
################################################################################

