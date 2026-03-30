// ThemeColor.swift
// PrajaktaKulkarniPortfolio
//
// Semantic color tokens for the portfolio design system.
// All UI colors must be sourced from ThemeColor, never hardcoded.
// Supports both light and dark mode automatically via adaptive colors.

import SwiftUI

/// Semantic color tokens for the entire app.
/// Use these instead of hardcoded Color values anywhere in UI code.
enum ThemeColor {

    // MARK: - Background Colors

    /// Primary app background (full screen canvas)
    static let primaryBackground = Color(.systemBackground)

    /// Secondary background for grouped sections
    static let secondaryBackground = Color(.secondarySystemBackground)

    /// Card surface background
    static let cardBackground = Color(.secondarySystemBackground)

    // MARK: - Text Colors

    /// Primary body and heading text
    static let primaryText = Color(.label)

    /// Secondary/supporting text (captions, subtitles)
    static let secondaryText = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(white: 0.72, alpha: 1.0)
            : UIColor(white: 0.30, alpha: 1.0)
    })

    /// Tertiary hint text
    static let tertiaryText = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(white: 0.58, alpha: 1.0)
            : UIColor(white: 0.42, alpha: 1.0)
    })

    // MARK: - Accent Colors

    /// Primary brand accent — used for highlights, buttons, progress indicators
    static let accentPrimary = Color("AccentPrimary", bundle: .main)

    /// Secondary accent — used for tags, badges, secondary actions
    static let accentSecondary = Color("AccentSecondary", bundle: .main)

    // MARK: - UI Element Colors

    /// Card drop shadow color
    static let cardShadow = Color(.sRGBLinear, white: 0, opacity: 0.12)

    /// Divider / separator lines
    static let divider = Color(.separator)

    /// Success indicator (e.g. current role badge)
    static let success = Color(.systemGreen)

    /// Skill tag background
    static let tagBackground = Color(.tertiarySystemBackground)

    // MARK: - Resume Brand Colors

    /// Primary brand blue — resume section headers, bullets, date labels
    static let resumePrimaryBlue = Color(red: 0.12, green: 0.28, blue: 0.55)

    /// Lighter gradient blue — resume banner gradient end colour
    static let resumeLightBlue = Color(red: 0.20, green: 0.45, blue: 0.75)

    /// Dark banner blue — resume contact sub-banner background
    static let resumeDarkBanner = Color(red: 0.08, green: 0.18, blue: 0.38)
}
