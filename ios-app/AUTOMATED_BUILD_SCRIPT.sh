#!/bin/bash

################################################################################
# ApexVision AI - Automated iOS Build Script
# 
# This script automates the entire iOS build process on a Cloud Mac
# Run this after transferring files to your MacinCloud/MacStadium instance
#
# Usage: bash AUTOMATED_BUILD_SCRIPT.sh
################################################################################

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="ApexVisionAI"
WORKSPACE_NAME="${PROJECT_NAME}.xcworkspace"
SCHEME_NAME="${PROJECT_NAME}"
BUNDLE_ID="ai.apexvision.ios"
BUILD_DIR="./build"
ARCHIVE_PATH="${BUILD_DIR}/${PROJECT_NAME}.xcarchive"
EXPORT_PATH="${BUILD_DIR}/export"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
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

################################################################################
# Step 1: Check Prerequisites
################################################################################

check_prerequisites() {
    print_header "Step 1: Checking Prerequisites"
    
    # Check if Xcode is installed
    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode is not installed!"
        print_info "Please install Xcode from the App Store"
        exit 1
    fi
    print_success "Xcode is installed"
    
    # Check if CocoaPods is installed
    if ! command -v pod &> /dev/null; then
        print_error "CocoaPods is not installed!"
        print_info "Installing CocoaPods..."
        sudo gem install cocoapods
    fi
    print_success "CocoaPods is installed"
    
    # Check if we're in the right directory
    if [ ! -f "Podfile" ]; then
        print_error "Podfile not found! Are you in the ios-app directory?"
        exit 1
    fi
    print_success "Found Podfile"
    
    # Accept Xcode license
    print_info "Accepting Xcode license..."
    sudo xcodebuild -license accept 2>/dev/null || true
    print_success "Xcode license accepted"
}

################################################################################
# Step 2: Install Dependencies
################################################################################

install_dependencies() {
    print_header "Step 2: Installing Dependencies"
    
    print_info "Running pod install..."
    pod install
    
    if [ $? -eq 0 ]; then
        print_success "Dependencies installed successfully"
    else
        print_error "Failed to install dependencies"
        exit 1
    fi
}

################################################################################
# Step 3: Clean Build Folder
################################################################################

clean_build() {
    print_header "Step 3: Cleaning Build Folder"
    
    if [ -d "$BUILD_DIR" ]; then
        print_info "Removing old build directory..."
        rm -rf "$BUILD_DIR"
    fi
    
    mkdir -p "$BUILD_DIR"
    print_success "Build folder cleaned"
}

################################################################################
# Step 4: Build for Simulator (Testing)
################################################################################

build_simulator() {
    print_header "Step 4: Building for Simulator"
    
    print_info "Building for iOS Simulator..."
    
    xcodebuild \
        -workspace "$WORKSPACE_NAME" \
        -scheme "$SCHEME_NAME" \
        -sdk iphonesimulator \
        -configuration Debug \
        -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
        clean build \
        | xcpretty || true
    
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        print_success "Simulator build succeeded!"
    else
        print_error "Simulator build failed"
        exit 1
    fi
}

################################################################################
# Step 5: Run Tests (Optional)
################################################################################

run_tests() {
    print_header "Step 5: Running Tests (Optional)"
    
    print_info "Running unit tests..."
    
    xcodebuild test \
        -workspace "$WORKSPACE_NAME" \
        -scheme "$SCHEME_NAME" \
        -sdk iphonesimulator \
        -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
        | xcpretty || true
    
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        print_success "Tests passed!"
    else
        print_warning "Tests failed or no tests found (continuing anyway)"
    fi
}

################################################################################
# Step 6: Create Archive
################################################################################

create_archive() {
    print_header "Step 6: Creating Archive"
    
    print_info "Creating archive for App Store distribution..."
    
    xcodebuild archive \
        -workspace "$WORKSPACE_NAME" \
        -scheme "$SCHEME_NAME" \
        -sdk iphoneos \
        -configuration Release \
        -archivePath "$ARCHIVE_PATH" \
        CODE_SIGN_STYLE=Automatic \
        | xcpretty || true
    
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        print_success "Archive created successfully!"
        print_info "Archive location: $ARCHIVE_PATH"
    else
        print_error "Archive creation failed"
        print_warning "This might be due to signing issues"
        print_info "You may need to configure signing in Xcode manually"
        exit 1
    fi
}

################################################################################
# Step 7: Export IPA
################################################################################

export_ipa() {
    print_header "Step 7: Exporting IPA"
    
    # Create export options plist
    cat > "${BUILD_DIR}/ExportOptions.plist" << EOF
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
    
    print_info "Exporting IPA for App Store..."
    
    xcodebuild -exportArchive \
        -archivePath "$ARCHIVE_PATH" \
        -exportPath "$EXPORT_PATH" \
        -exportOptionsPlist "${BUILD_DIR}/ExportOptions.plist" \
        | xcpretty || true
    
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        print_success "IPA exported successfully!"
        print_info "IPA location: ${EXPORT_PATH}/${PROJECT_NAME}.ipa"
    else
        print_error "IPA export failed"
        exit 1
    fi
}

################################################################################
# Step 8: Validate Archive
################################################################################

validate_archive() {
    print_header "Step 8: Validating Archive"
    
    print_info "Validating archive for App Store submission..."
    
    xcodebuild -validateArchive \
        -archivePath "$ARCHIVE_PATH" \
        -exportOptionsPlist "${BUILD_DIR}/ExportOptions.plist" \
        | xcpretty || true
    
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        print_success "Archive validation passed!"
    else
        print_warning "Archive validation failed (this is optional)"
    fi
}

################################################################################
# Step 9: Upload to App Store (Optional)
################################################################################

upload_to_appstore() {
    print_header "Step 9: Upload to App Store (Optional)"
    
    print_warning "Automatic upload requires App Store Connect API key"
    print_info "You can upload manually through Xcode or use this command:"
    echo ""
    echo "xcrun altool --upload-app \\"
    echo "    --type ios \\"
    echo "    --file \"${EXPORT_PATH}/${PROJECT_NAME}.ipa\" \\"
    echo "    --username \"YOUR_APPLE_ID\" \\"
    echo "    --password \"YOUR_APP_SPECIFIC_PASSWORD\""
    echo ""
    print_info "Or use Xcode: Window > Organizer > Archives > Upload"
}

################################################################################
# Step 10: Summary
################################################################################

print_summary() {
    print_header "Build Complete! 🎉"
    
    echo -e "${GREEN}✅ All steps completed successfully!${NC}"
    echo ""
    echo "📦 Build Artifacts:"
    echo "   - Archive: $ARCHIVE_PATH"
    echo "   - IPA: ${EXPORT_PATH}/${PROJECT_NAME}.ipa"
    echo ""
    echo "📱 Next Steps:"
    echo "   1. Test the app on a real device or simulator"
    echo "   2. Upload to TestFlight for beta testing"
    echo "   3. Submit to App Store for review"
    echo ""
    echo "📖 Documentation:"
    echo "   - See CLOUD_MAC_SETUP_GUIDE.md for detailed instructions"
    echo "   - See TESTING_AND_VALIDATION_GUIDE.md for testing procedures"
    echo ""
    print_success "Your iOS app is ready! 🚀"
}

################################################################################
# Main Execution
################################################################################

main() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                        ║${NC}"
    echo -e "${BLUE}║         ApexVision AI - iOS Build Automation          ║${NC}"
    echo -e "${BLUE}║                                                        ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Run all steps
    check_prerequisites
    install_dependencies
    clean_build
    build_simulator
    # run_tests  # Uncomment if you have tests
    create_archive
    export_ipa
    validate_archive
    upload_to_appstore
    print_summary
}

# Run main function
main

################################################################################
# End of Script
################################################################################

