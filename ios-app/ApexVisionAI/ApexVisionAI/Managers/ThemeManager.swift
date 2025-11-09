//
//  ThemeManager.swift
//  ApexVisionAI
//
//  Manages app theme and appearance settings
//  Colors extracted from Chrome Extension content.js v4.7.4
//

import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }

    @Published var fontSize: FontSize = .medium {
        didSet {
            UserDefaults.standard.set(fontSize.rawValue, forKey: "fontSize")
        }
    }

    private init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        if let savedSize = UserDefaults.standard.string(forKey: "fontSize"),
           let size = FontSize(rawValue: savedSize) {
            self.fontSize = size
        }
    }

    // MARK: - Core Theme Colors (Exact match to Chrome Extension)

    // Panel & Background Colors
    var panelBackground: Color {
        isDarkMode ? Color(hex: "282828") : Color(hex: "F1F1F2")
    }

    var chatOutputBackground: Color {
        isDarkMode ? Color(hex: "3E3E3E").opacity(0.22) : Color(hex: "EAE9EB")
    }

    var inputAreaBackground: Color {
        isDarkMode ? Color(hex: "3E3E3E").opacity(0.22) : Color(hex: "EAE9EB")
    }

    var sidebarBackground: Color {
        isDarkMode ? Color(hex: "3A3A3A") : Color(hex: "F5F5F5")
    }

    var entryBackground: Color {
        isDarkMode ? Color(hex: "302C2C") : Color(hex: "F9F9F9")
    }

    var entryHoverBackground: Color {
        isDarkMode ? Color(hex: "444444") : Color(hex: "E0E0E0")
    }

    // Text Colors
    var primaryText: Color {
        isDarkMode ? Color(hex: "F5F5F5") : Color(hex: "121212").opacity(0.83)
    }

    var secondaryText: Color {
        isDarkMode ? Color(hex: "CCCCCC") : Color(hex: "8E8E8E")
    }

    var titleColor: Color {
        isDarkMode ? Color(hex: "F1F1F2") : Color(hex: "333333")
    }

    var placeholderText: Color {
        isDarkMode ? Color(hex: "AAAAAA") : Color(hex: "888888")
    }

    // Search & Input Colors
    var searchBackground: Color {
        isDarkMode ? Color(hex: "2A2A2A") : Color(hex: "FFFFFF")
    }

    var searchBorder: Color {
        isDarkMode ? Color(hex: "444444") : Color(hex: "D0D0D0")
    }

    // MARK: - Message Bubble Colors

    // User Bubbles
    var userBubbleBackground: Color {
        isDarkMode ? Color(hex: "007BFF") : Color(hex: "0056B3")
    }

    var userBubbleText: Color {
        isDarkMode ? Color(hex: "F1F1F2") : Color(hex: "FFFFFF")
    }

    // AI Bubbles
    var aiBubbleBackground: Color {
        isDarkMode ? Color.white.opacity(0.05) : Color.black.opacity(0.03)
    }

    var aiBubbleBorder: Color {
        isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.08)
    }

    var aiBubbleText: Color {
        isDarkMode ? Color(hex: "F1F1F2") : Color(hex: "333333")
    }

    var aiBubbleCodeBackground: Color {
        isDarkMode ? Color(hex: "1E1E2E") : Color(hex: "E0E0E0")
    }

    var aiBubbleCodeText: Color {
        isDarkMode ? Color(hex: "E6E6E6") : Color(hex: "2E2E2E")
    }

    // MARK: - Accent Colors (Theme-Independent)

    var primaryBlue: Color {
        Color(hex: "4A90E2")
    }

    var primaryBlueHover: Color {
        Color(hex: "5BA3F5")
    }

    var successGreen: Color {
        Color(hex: "4CAF50")
    }

    var warningOrange: Color {
        Color(hex: "FF9800")
    }

    var errorRed: Color {
        Color(hex: "F44336")
    }

    var infoBlue: Color {
        Color(hex: "1E90FF")
    }

    // MARK: - Button Colors

    var buttonPrimary: Color {
        isDarkMode ? Color(hex: "007BFF") : Color(hex: "0056B3")
    }

    var buttonPrimaryHover: Color {
        isDarkMode ? Color(hex: "0056B3") : Color(hex: "004494")
    }

    var buttonPrimaryText: Color {
        isDarkMode ? Color(hex: "F5F5F5") : Color(hex: "FFFFFF")
    }

    var buttonSecondary: Color {
        isDarkMode ? Color(hex: "2A2A2A") : Color(hex: "F8F9FA")
    }

    var buttonSecondaryBorder: Color {
        isDarkMode ? Color(hex: "444444") : Color(hex: "E0E0E0")
    }

    var buttonSecondaryText: Color {
        isDarkMode ? Color(hex: "F5F5F5") : Color(hex: "333333")
    }

    // MARK: - Scrollbar Colors

    var scrollbarTrack: Color {
        isDarkMode ? Color(hex: "444444") : Color(hex: "CCCCCC")
    }

    var scrollbarThumb: Color {
        isDarkMode ? Color(hex: "888888") : Color(hex: "AAAAAA")
    }

    // MARK: - Special UI Elements

    var copyIcon: Color {
        isDarkMode ? Color(hex: "AAAAAA") : Color(hex: "555555")
    }

    var copyIconHover: Color {
        isDarkMode ? Color(hex: "FFFFFF") : Color(hex: "000000")
    }

    var copyIconSuccess: Color {
        Color(hex: "4CAF50")
    }

    var tooltipBackground: Color {
        Color.black.opacity(0.75)
    }

    var tooltipText: Color {
        Color.white
    }

    // MARK: - Toggle/Switch Colors

    var toggleInactive: Color {
        Color(hex: "4E4E4E")
    }

    var toggleActive: Color {
        Color(hex: "5B9FDD")
    }

    var toggleKnob: Color {
        Color(hex: "FFFFFF")
    }

    var toggleDisabled: Color {
        Color(hex: "B3B3B3")
    }

    // MARK: - Gradients

    var mastermindGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: "5E99BD"),
                Color(hex: "6CCFF6"),
                Color(hex: "A390E4"),
                Color(hex: "FF6B6B")
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    // MARK: - Progress Colors

    func progressColor(percentage: Double) -> Color {
        if percentage >= 80 {
            return Color(hex: "F44336") // Red
        } else if percentage >= 60 {
            return Color(hex: "FF9800") // Orange
        } else if percentage >= 40 {
            return Color(hex: "FFC107") // Yellow
        } else {
            return Color(hex: "4CAF50") // Green
        }
    }

    // MARK: - Font Sizes

    enum FontSize: String, CaseIterable {
        case small = "Small"
        case medium = "Medium"
        case large = "Large"
        case extraLarge = "Extra Large"

        var multiplier: CGFloat {
            switch self {
            case .small: return 0.85
            case .medium: return 1.0
            case .large: return 1.15
            case .extraLarge: return 1.3
            }
        }
    }

    func font(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size * fontSize.multiplier, weight: weight)
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

