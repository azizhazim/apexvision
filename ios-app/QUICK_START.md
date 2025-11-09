# ApexVision AI iOS App - Quick Start Guide

## 🚀 Get Started in 5 Minutes (on Mac)

This guide will get you up and running with the ApexVision AI iOS app as quickly as possible.

---

## ⚠️ Prerequisites

Before you begin, make sure you have:

- ✅ **macOS** (Ventura 13.0 or later)
- ✅ **Xcode** (14.0 or later) - [Download from App Store](https://apps.apple.com/app/xcode/id497799835)
- ✅ **CocoaPods** - Install with: `sudo gem install cocoapods`
- ✅ **Apple Developer Account** (free account works for simulator)

---

## 📋 Quick Setup (5 Steps)

### Step 1: Open Terminal

```bash
# Navigate to the ios-app directory
cd path/to/ApexVision-AI-ChromeExtension/ios-app
```

### Step 2: Run Setup Script

```bash
# Make script executable and run
chmod +x setup.sh
./setup.sh
```

This will:
- Check for required tools
- Install CocoaPods dependencies
- Verify project structure

### Step 3: Configure Firebase

**Option A: Use Existing Firebase Project**

1. Download `GoogleService-Info.plist` from [Firebase Console](https://console.firebase.google.com/)
2. Replace the template file:
   ```bash
   cp ~/Downloads/GoogleService-Info.plist ApexVisionAI/ApexVisionAI/
   ```

**Option B: Use Template (for testing only)**

The template is already in place, but you'll need to add your Firebase API key.

### Step 4: Open Workspace

```bash
# IMPORTANT: Open .xcworkspace, NOT .xcodeproj
open ApexVisionAI.xcworkspace
```

### Step 5: Build & Run

1. In Xcode, select a simulator (e.g., "iPhone 15 Pro")
2. Press `Cmd + R` or click the Play button
3. Wait for build to complete
4. App will launch in simulator

---

## 🎉 Success!

You should now see the ApexVision AI app running with:

- ✅ Login screen with Google Sign-In
- ✅ 5 main tabs (Chat, Scan, Exam Prep, Essay, More)
- ✅ All features accessible

---

## 🔧 Troubleshooting

### "No such module 'Firebase'"

```bash
# Clean and reinstall pods
pod deintegrate
pod install
```

Then in Xcode: `Cmd + Shift + K` (Clean Build Folder)

### "GoogleService-Info.plist not found"

Make sure the file is in the correct location:
```
ApexVisionAI/ApexVisionAI/GoogleService-Info.plist
```

### Build fails

1. Clean build folder: `Cmd + Shift + K`
2. Close Xcode
3. Delete derived data:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
4. Reopen workspace and build

### Simulator doesn't launch

```bash
# Reset all simulators
xcrun simctl erase all
```

---

## 📱 Testing the App

### 1. Authentication
- Tap "Sign in with Google"
- Complete Google Sign-In flow
- Should redirect to main app

### 2. AI Chat
- Go to "Chat" tab
- Type a question
- Tap send or use quick actions

### 3. Image Analysis
- Go to "Scan" tab
- Tap camera or photo library
- Select/take an image
- View analysis results

### 4. Exam Prediction
- Go to "Exam Prep" tab
- Enter course name and professor
- Upload course materials
- View predicted questions

### 5. Essay Writer
- Go to "Essay" tab
- Enter topic and settings
- Generate essay
- View PDF

### 6. More Features
- Go to "More" tab
- Try Flashcards, Math Solver, Code Helper, etc.

---

## 🎯 Next Steps

### For Development

1. **Read the Documentation**
   - [README.md](README.md) - Feature overview
   - [INSTALLATION.md](INSTALLATION.md) - Detailed setup
   - [FILE_STRUCTURE.md](FILE_STRUCTURE.md) - Code organization

2. **Explore the Code**
   - Views: `ApexVisionAI/ApexVisionAI/Views/`
   - Managers: `ApexVisionAI/ApexVisionAI/Managers/`
   - Models: `ApexVisionAI/ApexVisionAI/Models/`

3. **Make Changes**
   - Edit SwiftUI views
   - Update API endpoints
   - Customize theme colors

### For Testing

1. **Test on Physical Device**
   - Connect iPhone/iPad via USB
   - Select device in Xcode
   - Build and run

2. **Test All Features**
   - Go through each tab
   - Try all quick actions
   - Test dark mode
   - Test different font sizes

3. **Test Edge Cases**
   - No internet connection
   - Invalid inputs
   - Large images
   - Long text

### For Deployment

1. **Prepare Assets**
   - Add app icons (1024x1024)
   - Create screenshots
   - Write App Store description

2. **Configure for Release**
   - Update version number
   - Set up signing certificates
   - Configure provisioning profiles

3. **Archive and Submit**
   - Product → Archive
   - Distribute to App Store
   - Submit for review

---

## 📚 Additional Resources

### Documentation
- [README.md](README.md) - Complete feature list
- [INSTALLATION.md](INSTALLATION.md) - Detailed installation
- [IOS_APP_COMPLETE_SUMMARY.md](IOS_APP_COMPLETE_SUMMARY.md) - Implementation details
- [FILE_STRUCTURE.md](FILE_STRUCTURE.md) - File organization

### External Links
- [Apple Developer](https://developer.apple.com/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)
- [Google Sign-In iOS](https://developers.google.com/identity/sign-in/ios)

### Support
- **Website**: https://apexvision.ai
- **YouTube**: @ApexVisionAI
- **Instagram**: @apexvision.ai
- **TikTok**: @apexvisionai

---

## 💡 Tips

### Development Tips

1. **Use Simulator for Quick Testing**
   - Faster than device
   - Easy to reset
   - Multiple device sizes

2. **Enable Debug Logging**
   - Add `print()` statements
   - Check Xcode console
   - Use breakpoints

3. **Hot Reload**
   - SwiftUI previews update live
   - Use `#Preview` macros
   - Faster than full rebuild

### Performance Tips

1. **Optimize Images**
   - Compress before upload
   - Use appropriate sizes
   - Cache when possible

2. **Minimize API Calls**
   - Cache responses
   - Debounce user input
   - Use local storage

3. **Profile with Instruments**
   - Check memory usage
   - Monitor network calls
   - Identify bottlenecks

---

## ✅ Checklist

Before considering the app "ready":

- [ ] App builds without errors
- [ ] All tabs are accessible
- [ ] Google Sign-In works
- [ ] AI chat responds correctly
- [ ] Image analysis works
- [ ] Exam prediction generates questions
- [ ] Essay writer creates PDFs
- [ ] All additional tools work
- [ ] Dark mode toggles correctly
- [ ] Font size changes work
- [ ] Settings save properly
- [ ] App doesn't crash on common actions

---

## 🎊 You're All Set!

The ApexVision AI iOS app is now running on your Mac. Start exploring, testing, and customizing!

**Happy Coding! 🚀**

---

**Last Updated**: 2025-01-09
**Version**: 1.0.0

