# ApexVision AI iOS App - Installation Guide

This guide will walk you through setting up and running the ApexVision AI iOS app on your Mac.

## Prerequisites

### Required Software

1. **macOS** (Ventura 13.0 or later recommended)
2. **Xcode 14.0 or later**
   - Download from the Mac App Store
   - Or download from [Apple Developer](https://developer.apple.com/xcode/)
3. **CocoaPods**
   - Package manager for iOS dependencies
4. **Active Apple Developer Account** (for device testing)
   - Free account works for simulator testing
   - Paid account ($99/year) required for App Store distribution

### System Requirements

- Mac with Apple Silicon (M1/M2/M3) or Intel processor
- At least 20GB of free disk space
- Internet connection for downloading dependencies

## Step-by-Step Installation

### 1. Install Xcode

If you haven't already:

```bash
# Open Mac App Store and search for "Xcode"
# Or use command line:
open "macappstore://apps.apple.com/app/xcode/id497799835"
```

After installation, open Xcode once to accept the license agreement:

```bash
sudo xcodebuild -license accept
```

Install Xcode Command Line Tools:

```bash
xcode-select --install
```

### 2. Install CocoaPods

CocoaPods is required for managing iOS dependencies:

```bash
# Install CocoaPods
sudo gem install cocoapods

# Verify installation
pod --version
```

If you encounter permission issues, you can use Homebrew instead:

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install CocoaPods via Homebrew
brew install cocoapods
```

### 3. Navigate to Project Directory

```bash
cd ios-app
```

### 4. Run Setup Script

We've provided an automated setup script:

```bash
# Make the script executable
chmod +x setup.sh

# Run the setup
./setup.sh
```

This script will:
- Check for required tools
- Install CocoaPods dependencies
- Verify project structure
- Provide next steps

**Alternative Manual Setup:**

If the script doesn't work, you can manually install dependencies:

```bash
# Install pods
pod install

# If you get errors, try:
pod repo update
pod install --repo-update
```

### 5. Configure Firebase

The app requires Firebase for authentication and data storage.

#### Option A: Use Existing Firebase Project

If you already have the Firebase project set up:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your ApexVision AI project
3. Click the iOS icon to add an iOS app
4. Enter Bundle ID: `ai.apexvision.ios`
5. Download `GoogleService-Info.plist`
6. Replace the template file:
   ```bash
   # Backup template
   mv ApexVisionAI/ApexVisionAI/GoogleService-Info.plist ApexVisionAI/ApexVisionAI/GoogleService-Info.plist.template
   
   # Copy your downloaded file
   cp ~/Downloads/GoogleService-Info.plist ApexVisionAI/ApexVisionAI/
   ```

#### Option B: Create New Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Name it "ApexVision AI"
4. Enable Google Analytics (optional)
5. Add an iOS app with Bundle ID: `ai.apexvision.ios`
6. Download `GoogleService-Info.plist`
7. Enable Authentication:
   - Go to Authentication → Sign-in method
   - Enable Google Sign-In
   - Add your iOS client ID
8. Enable Firestore:
   - Go to Firestore Database
   - Create database in production mode
   - Set up security rules

### 6. Open the Workspace

**IMPORTANT:** Always open the `.xcworkspace` file, NOT the `.xcodeproj` file!

```bash
open ApexVisionAI.xcworkspace
```

Or double-click `ApexVisionAI.xcworkspace` in Finder.

### 7. Configure Signing

In Xcode:

1. Select the project in the navigator (blue icon at top)
2. Select the "ApexVisionAI" target
3. Go to "Signing & Capabilities" tab
4. Check "Automatically manage signing"
5. Select your Team from the dropdown
   - If you don't see your team, sign in with your Apple ID in Xcode Preferences

### 8. Build and Run

#### For Simulator (Recommended for Testing)

1. Select a simulator from the device menu (e.g., "iPhone 15 Pro")
2. Press `Cmd + R` or click the Play button
3. Wait for the build to complete
4. The app will launch in the simulator

#### For Physical Device

1. Connect your iPhone/iPad via USB
2. Trust the computer on your device
3. Select your device from the device menu
4. Press `Cmd + R`
5. On first run, you may need to trust the developer certificate:
   - Settings → General → VPN & Device Management
   - Trust your developer certificate

### 9. Verify Installation

Once the app launches:

1. You should see the login screen with ApexVision AI branding
2. Tap "Sign in with Google"
3. Complete the Google Sign-In flow
4. You should be taken to the main app with 5 tabs

## Building from Command Line

### Using the Build Script

```bash
# Make executable
chmod +x build.sh

# Build for simulator (default)
./build.sh

# Build for device
./build.sh --device

# Clean build
./build.sh --clean

# Debug build
./build.sh --debug
```

### Manual Build Commands

```bash
# Build for simulator
xcodebuild \
  -workspace ApexVisionAI.xcworkspace \
  -scheme ApexVisionAI \
  -configuration Release \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
  build

# Build for device
xcodebuild \
  -workspace ApexVisionAI.xcworkspace \
  -scheme ApexVisionAI \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  build
```

## Troubleshooting

### Common Issues

#### 1. "No such module 'Firebase'" or similar errors

**Solution:**
```bash
# Clean and reinstall pods
pod deintegrate
pod install
```

Then clean build folder in Xcode: `Cmd + Shift + K`

#### 2. Code signing errors

**Solution:**
- Ensure you're signed in to Xcode with your Apple ID
- Check "Automatically manage signing" in project settings
- Try changing the Bundle Identifier to something unique

#### 3. "GoogleService-Info.plist not found"

**Solution:**
- Ensure the file is in `ApexVisionAI/ApexVisionAI/` directory
- In Xcode, verify it's added to the target (check the file inspector)

#### 4. Build fails with "Command PhaseScriptExecution failed"

**Solution:**
```bash
# Update CocoaPods
sudo gem install cocoapods
pod repo update
pod install
```

#### 5. Simulator doesn't launch

**Solution:**
```bash
# Reset simulator
xcrun simctl erase all

# Or in Simulator app: Device → Erase All Content and Settings
```

#### 6. "Unable to install" on device

**Solution:**
- Check that your device iOS version is 15.0 or later
- Ensure your provisioning profile is valid
- Try deleting the app from device and reinstalling

### Getting Help

If you encounter issues not covered here:

1. Check the [README.md](README.md) for additional information
2. Review Xcode build logs for specific error messages
3. Ensure all prerequisites are properly installed
4. Try a clean build: `Cmd + Shift + K` then `Cmd + B`

## Next Steps

After successful installation:

1. **Test Core Features:**
   - AI Chat
   - Image Analysis (requires camera permission)
   - Exam Prediction
   - Essay Writer

2. **Configure Backend:**
   - Ensure the backend API is running at `https://api.apexvision.ai`
   - Test authentication flow
   - Verify all endpoints are accessible

3. **Customize:**
   - Update app icons in Assets.xcassets
   - Modify theme colors in ThemeManager.swift
   - Adjust API endpoints if needed

4. **Prepare for Distribution:**
   - See [App Store submission guide](https://developer.apple.com/app-store/submissions/)
   - Configure app metadata
   - Create screenshots
   - Set up TestFlight for beta testing

## Development Workflow

### Running Tests

```bash
# Run unit tests
xcodebuild test \
  -workspace ApexVisionAI.xcworkspace \
  -scheme ApexVisionAI \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# Or in Xcode: Cmd + U
```

### Debugging

- Set breakpoints by clicking line numbers
- Use `print()` statements for logging
- View console output in Xcode's debug area
- Use Instruments for performance profiling

### Making Changes

1. Create a new branch for features
2. Make your changes
3. Test thoroughly
4. Build for both simulator and device
5. Commit and push changes

## Production Build

For App Store submission:

1. Archive the app: `Product → Archive`
2. Wait for archive to complete
3. Click "Distribute App"
4. Choose "App Store Connect"
5. Follow the wizard
6. Upload to TestFlight or submit for review

---

**Congratulations!** You should now have the ApexVision AI iOS app running on your device or simulator.

For questions or issues, refer to the main [README.md](README.md) or contact the development team.

