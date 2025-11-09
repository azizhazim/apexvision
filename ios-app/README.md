# ApexVision AI - iOS App

A comprehensive iOS companion app for the ApexVision AI Chrome Extension, providing AI-powered homework assistance, image analysis, exam prediction, and more.

## ✨ Latest Updates (2025-11-09)

### 🎨 Perfect Chrome Extension Matching
- **Exact Color Scheme**: All colors extracted from Chrome extension v4.7.4
- **Theme Consistency**: Light/dark mode matches web experience 100%
- **Professional UI**: Polished interface with proper spacing and shadows

### 🔐 Enhanced Authentication
- **Apple Sign-In**: Native iOS authentication with Apple ID
- **Google Sign-In**: Existing authentication method
- **Account Sync**: Same account works across iOS and Chrome extension
- **Seamless Linking**: Backend automatically links accounts

### 🔧 Backend Integration
- **Production Firebase**: Real configuration (apex-vision-388417)
- **Verified Endpoints**: All API endpoints tested and working
- **Subscription Sync**: Request counts and tiers sync perfectly
- **Error Handling**: Robust error handling throughout

### 📊 Subscription Tiers
| Tier | Requests/Month | Features |
|------|----------------|----------|
| **Free** | 15 total | Basic features |
| **Knowledge Kickstart** | 500 | All features |
| **Savvy Scholar** | 1,000 | All features |
| **Mastermind** | 2,000 | All features + Mathpix OCR |

## Features

### 🤖 AI Chat Assistant
- Real-time AI-powered chat for homework help
- Quick action buttons for common tasks
- Chat history and session management
- Support for multiple conversation threads

### 📸 Image Analysis
- Camera and photo library integration
- OCR and image-to-text conversion
- Advanced math processing with Mathpix (Mastermind subscribers)
- Instant problem solving from images

### 🎓 Exam Prediction
- Upload course materials (PDFs, text files)
- AI-powered exam question prediction
- Difficulty ratings and study tips
- Detailed explanations for each predicted question

### ✍️ Essay Writer
- Professional essay generation
- Multiple citation styles (MLA, APA, Chicago, Harvard)
- Customizable word count, tone, and academic level
- PDF export and sharing

### 📚 Additional Tools
- **Flashcards Generator**: Create study flashcards from any topic
- **Math Solver**: Step-by-step math problem solutions
- **Code Helper**: Programming assistance and code generation
- **Study Guide Generator**: Comprehensive study guides from notes
- **Leaderboard**: Track your progress and compete with others

## Requirements

- iOS 15.0 or later
- Xcode 14.0 or later
- CocoaPods
- Active ApexVision AI account

## Installation

### 1. Clone the Repository

```bash
cd ios-app
```

### 2. Install Dependencies

```bash
pod install
```

### 3. Configure Firebase

1. Download `GoogleService-Info.plist` from your Firebase project
2. Add it to the `ApexVisionAI` folder in Xcode
3. Ensure it's added to the target

### 4. Open Workspace

```bash
open ApexVisionAI.xcworkspace
```

### 5. Build and Run

1. Select your target device or simulator
2. Press `Cmd + R` to build and run

## Configuration

### API Endpoint

The app connects to the backend at `https://api.apexvision.ai`. To change this:

1. Open `NetworkManager.swift`
2. Update the `baseURL` constant

### Authentication

The app supports both Google Sign-In and Apple Sign-In:

**Google Sign-In**:
- Client ID configured in `Info.plist` (GIDClientID)
- URL scheme in `Info.plist` (CFBundleURLSchemes)
- Firebase configuration in `GoogleService-Info.plist`

**Apple Sign-In**:
- Native iOS authentication
- Automatic capability in Xcode
- Secure nonce generation for security

## Project Structure

```
ApexVisionAI/
├── ApexVisionAIApp.swift          # App entry point
├── ContentView.swift              # Main navigation
├── Managers/
│   ├── AuthenticationManager.swift # Auth & user management
│   ├── NetworkManager.swift        # API communication
│   └── ThemeManager.swift          # Theme & appearance
├── Models/
│   └── APIModels.swift            # Data models
├── Views/
│   ├── ChatView.swift             # AI chat interface
│   ├── ImageAnalysisView.swift    # Image scanning
│   ├── ExamPredictionView.swift   # Exam prediction
│   ├── EssayWriterView.swift      # Essay generation
│   ├── FlashcardsView.swift       # Flashcard study
│   ├── MathSolverView.swift       # Math solver
│   ├── CodeHelperView.swift       # Code assistance
│   ├── StudyGuideView.swift       # Study guides
│   ├── LeaderboardView.swift      # Leaderboard
│   ├── SettingsView.swift         # App settings
│   ├── HistoryView.swift          # Chat history
│   ├── AuthenticationView.swift   # Login screen
│   ├── MoreFeaturesView.swift     # Additional features
│   └── PredictionDetailView.swift # Exam question details
├── ViewModels/
│   └── ChatViewModel.swift        # Chat logic
└── Helpers/
    ├── ImagePicker.swift          # Image selection
    └── DocumentPicker.swift       # File selection
```

## Features by Subscription Level

### Free Tier
- 10 free requests
- Basic AI chat
- Image analysis
- Limited features

### Knowledge Kickstart
- 100 requests/month
- All basic features
- Essay writer
- Study guides

### Savvy Scholar
- 500 requests/month
- All features
- Priority support
- Advanced tools

### Mastermind
- Unlimited requests
- All premium features
- Advanced math processing (Mathpix)
- Exam prediction
- Priority support

## API Integration

The app integrates with the following backend endpoints:

- `/google_login` - Google authentication
- `/get_side_panel_gpt_response` - AI chat
- `/analyze_image` - Image analysis
- `/exam_prediction/predict` - Exam predictions
- `/exam_prediction/generate_answer` - Question answers
- `/exam_prediction/check_limit` - Usage limits
- `/generate_essay` - Essay generation
- `/study_guide_module` - Study guides
- `/flashcards` - Flashcard generation
- `/math` - Math solving
- `/code` - Code assistance
- `/leaderboard/submit` - Submit stats
- `/leaderboard/get` - Get leaderboard

## Testing

### Unit Tests

```bash
# Run tests
Cmd + U
```

### UI Tests

```bash
# Run UI tests
Cmd + U (with UI test target selected)
```

## Building for Release

### 1. Update Version

Update version in:
- `Info.plist` (CFBundleShortVersionString)
- `Info.plist` (CFBundleVersion)

### 2. Archive

1. Select "Any iOS Device" as target
2. Product → Archive
3. Wait for archive to complete

### 3. Distribute

1. Click "Distribute App"
2. Choose distribution method (App Store, Ad Hoc, etc.)
3. Follow the wizard

## Troubleshooting

### Build Errors

**Pod install fails:**
```bash
pod repo update
pod install --repo-update
```

**Firebase errors:**
- Ensure `GoogleService-Info.plist` is added to the project
- Check that it's included in the target

**Google Sign-In errors:**
- Verify client ID in `Info.plist`
- Check URL schemes configuration

### Runtime Issues

**Network errors:**
- Check internet connection
- Verify API endpoint is accessible
- Check authentication token

**Image picker not working:**
- Verify camera/photo library permissions in `Info.plist`
- Check device permissions in Settings

## Contributing

This is a proprietary project for ApexVision AI. For issues or feature requests, contact the development team.

## Support

- Website: https://apexvision.ai
- YouTube: @ApexVisionAI
- Instagram: @apexvision.ai
- TikTok: @apexvisionai

## License

Copyright © 2025 ApexVision AI. All rights reserved.

## Version History

### 1.0.0 (2025-01-09)
- Initial release
- AI chat assistant
- Image analysis with OCR
- Exam prediction
- Essay writer
- Flashcards, math solver, code helper
- Study guide generator
- Leaderboard
- Google Sign-In authentication
- Dark mode support
- Customizable font sizes

