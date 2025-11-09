# Chrome Extension Color Palette - ApexVision AI

This document contains the **exact** color scheme extracted from the Chrome extension (`content.js`) for use in the iOS app.

## 🎨 Core Theme Colors

### Light Theme
```swift
// Panel & Background Colors
panelBackground: #F1F1F2          // Main panel background
chatOutputBackground: #EAE9EB     // Chat area background
inputAreaBackground: #EAE9EB      // Input area background
sidebarBackground: #F5F5F5        // Sidebar background
entryBackground: #F9F9F9          // History entry background
entryHoverBackground: #E0E0E0     // History entry hover

// Text Colors
primaryText: #121212D4            // Main text color (with alpha)
secondaryText: #8E8E8E            // Secondary/muted text
titleColor: #333333               // Titles and headers
placeholderText: #888888          // Input placeholders

// UI Element Colors
searchBackground: #FFFFFF         // Search input background
searchBorder: #D0D0D0             // Search input border
```

### Dark Theme
```swift
// Panel & Background Colors
panelBackground: #282828          // Main panel background
chatOutputBackground: #3E3E3E38   // Chat area background (with alpha)
inputAreaBackground: #3E3E3E38    // Input area background (with alpha)
sidebarBackground: #3A3A3A        // Sidebar background
entryBackground: #302C2C          // History entry background
entryHoverBackground: #444444     // History entry hover

// Text Colors
primaryText: #F5F5F5              // Main text color
secondaryText: #CCCCCC            // Secondary/muted text
titleColor: #F1F1F2               // Titles and headers
placeholderText: #AAAAAA          // Input placeholders

// UI Element Colors
searchBackground: #2A2A2A         // Search input background
searchBorder: #444444             // Search input border
```

## 💬 Message Bubbles

### User Bubbles (Both Themes)
```swift
// Light Theme
userBubbleBackground: #0056B3     // Blue background
userBubbleText: #FFFFFF           // White text

// Dark Theme
userBubbleBackground: #007BFF     // Brighter blue background
userBubbleText: #F1F1F2           // Light text

// Hover Effects (Both Themes)
userBubbleHoverShadow: [
    "0 4px 12px rgba(74, 144, 226, 0.45)",
    "0 8px 24px rgba(91, 163, 245, 0.35)",
    "0 0 20px rgba(123, 184, 255, 0.25)"
]
```

### AI Bubbles

#### Light Theme
```swift
aiBubbleBackground: rgba(0, 0, 0, 0.03)  // Very subtle gray
aiBubbleBorder: rgba(0, 0, 0, 0.08)      // Subtle border
aiBubbleText: #333333                     // Dark text
aiBubbleCodeBackground: #E0E0E0           // Code block background
aiBubbleCodeText: #2E2E2E                 // Code text
aiBubbleInlineCodeBg: rgba(0, 0, 0, 0.05) // Inline code background
aiBubbleBlockquoteBg: rgba(0, 0, 0, 0.03) // Blockquote background
aiBubbleBlockquoteBorder: rgba(0, 0, 0, 0.2) // Blockquote left border
```

#### Dark Theme
```swift
aiBubbleBackground: rgba(255, 255, 255, 0.05)  // Subtle white overlay
aiBubbleBorder: rgba(255, 255, 255, 0.1)       // Subtle border
aiBubbleText: #F1F1F2                          // Light text
aiBubbleCodeBackground: #1E1E2E                // Deep slate for code
aiBubbleCodeText: #E6E6E6                      // Light code text
aiBubbleInlineCodeBg: #2A2A3A                  // Inline code background
aiBubbleBlockquoteBg: rgba(255, 255, 255, 0.05) // Blockquote background
aiBubbleBlockquoteBorder: #444444              // Blockquote left border
```

## 🎯 Accent Colors (Theme-Independent)

```swift
// Primary Accent
primaryBlue: #4A90E2              // Main accent color
primaryBlueHover: #5BA3F5         // Hover state

// Success
successGreen: #4CAF50             // Success messages
successGreenLight: #8BC34A        // Light success

// Warning
warningOrange: #FF9800            // Warning messages
warningYellow: #FFC107            // Medium warning

// Error
errorRed: #F44336                 // Error messages
errorRedDark: #FF4444             // Dark error

// Info
infoBlue: #1E90FF                 // Information messages

// Special Features
mastermindGradient: [             // Mastermind feature gradient
    "#5E99BD",
    "#6CCFF6",
    "#A390E4",
    "#FF6B6B"
]

// Toggle/Switch Colors
toggleInactive: #4E4E4E           // Inactive toggle background
toggleActive: #5B9FDD             // Active toggle background
toggleKnob: #FFFFFF               // Toggle knob color
toggleDisabled: #B3B3B3           // Disabled toggle knob
```

## 📊 Progress & Status Colors

```swift
// Progress Bar Colors (Dynamic based on usage)
progressGreen: #4CAF50            // 0-40% usage
progressYellow: #FFC107           // 40-60% usage
progressOrange: #FF9800           // 60-80% usage
progressRed: #F44336              // 80-100% usage

// Badge Colors
badgeGold: #FFD700                // Achievement badges
badgeOrange: #FFA500              // Special badges
```

## 🔘 Button Colors

### Primary Buttons
```swift
// Light Theme
buttonPrimary: #0056B3            // Primary button background
buttonPrimaryHover: #004494       // Primary button hover
buttonPrimaryText: #FFFFFF        // Primary button text

// Dark Theme
buttonPrimary: #007BFF            // Primary button background
buttonPrimaryHover: #0056B3       // Primary button hover
buttonPrimaryText: #F5F5F5        // Primary button text
```

### Secondary Buttons
```swift
// Light Theme
buttonSecondary: #F8F9FA          // Secondary button background
buttonSecondaryBorder: #E0E0E0    // Secondary button border
buttonSecondaryText: #333333      // Secondary button text

// Dark Theme
buttonSecondary: #2A2A2A          // Secondary button background
buttonSecondaryBorder: #444444    // Secondary button border
buttonSecondaryText: #F5F5F5      // Secondary button text
```

### Action Buttons (Gradient)
```swift
baseColor: #5E99BD                // Base gradient color
hoverColor: #6CCFF6               // Hover gradient color
borderColor: #A390E4              // Border color
textColor: #F7F7F7                // Text color
```

## 📜 Scrollbar Colors

### Light Theme
```swift
scrollbarTrack: #CCCCCC           // Scrollbar track
scrollbarThumb: #AAAAAA           // Scrollbar thumb
scrollbarThumbHover: #888888      // Scrollbar thumb hover
```

### Dark Theme
```swift
scrollbarTrack: #444444           // Scrollbar track
scrollbarThumb: #888888           // Scrollbar thumb
scrollbarThumbHover: #AAAAAA      // Scrollbar thumb hover
```

## 🎨 Code Syntax Highlighting

```swift
// Syntax Colors (Used in both themes)
syntaxComment: #6A9955            // Comments
syntaxString: #CE9178             // Strings
syntaxKeyword: #C586C0            // Keywords
syntaxNumber: #B5CEA8             // Numbers
syntaxFunction: #DCDCAA           // Functions
```

## 🔍 Special UI Elements

### Copy Icon
```swift
// Light Theme
copyIcon: #555555                 // Default state
copyIconHover: #000000            // Hover state
copyIconSuccess: #4CAF50          // Success state

// Dark Theme
copyIcon: #AAAAAA                 // Default state
copyIconHover: #FFFFFF            // Hover state
copyIconSuccess: #4CAF50          // Success state
```

### Tooltips
```swift
tooltipBackground: rgba(0, 0, 0, 0.75)  // Tooltip background
tooltipText: #FFFFFF                     // Tooltip text
tooltipPadding: 5px 8px                  // Tooltip padding
```

### Highlight Popup
```swift
popupBackground: #FFFFFF          // Popup background
popupText: #333333                // Popup text
popupBorder: #E0E0E0              // Popup border
popupHover: #F0F0F0               // Popup item hover
```

## 🎭 Glassmorphism Effects

```swift
// AI Bubble Glassmorphism
backdropBlur: 10px                // Blur amount
lightThemeBorder: rgba(0, 0, 0, 0.08)     // Light theme border
darkThemeBorder: rgba(255, 255, 255, 0.1) // Dark theme border
```

## 📱 iOS Implementation Notes

### Color Conversion
All colors should be converted to SwiftUI Color using:
```swift
Color(hex: "#HEXCODE")
```

### Alpha Values
- `#121212D4` = #121212 with ~83% opacity
- `#3E3E3E38` = #3E3E3E with ~22% opacity
- Use `.opacity()` modifier in SwiftUI

### Gradients
Use `LinearGradient` for multi-color gradients:
```swift
LinearGradient(
    colors: [Color(hex: "#5E99BD"), Color(hex: "#6CCFF6"), ...],
    startPoint: .leading,
    endPoint: .trailing
)
```

### Shadows
Convert CSS box-shadow to SwiftUI:
```swift
.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
```

---

## ✅ Verification Checklist

- [ ] All hex codes extracted from content.js
- [ ] Light and dark theme colors separated
- [ ] Alpha values properly documented
- [ ] Gradient colors in correct order
- [ ] Special state colors included (hover, active, disabled)
- [ ] Syntax highlighting colors documented
- [ ] Scrollbar colors included
- [ ] Button states documented
- [ ] iOS implementation notes added

---

**Last Updated**: Based on content.js version 4.7.4
**Source**: public/content.js lines 1107-7730

