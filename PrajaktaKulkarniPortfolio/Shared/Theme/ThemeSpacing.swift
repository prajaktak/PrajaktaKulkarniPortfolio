// ThemeSpacing.swift
// PrajaktaKulkarniPortfolio
//
// Spacing and layout constants for the portfolio design system.
// Use these tokens instead of magic numbers throughout all views.

import Foundation

/// Layout spacing and sizing constants.
/// All padding, margin, and corner radius values must come from ThemeSpacing.
enum ThemeSpacing {

    // MARK: - Base Scale (4-point grid)

    static let extraSmall: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let extraLarge: CGFloat = 32
    static let huge: CGFloat = 48

    // MARK: - Card-Specific

    /// Internal padding inside a card
    static let cardPadding: CGFloat = 20

    /// Corner radius for all card surfaces
    static let cardCornerRadius: CGFloat = 20

    /// Card drop shadow radius
    static let cardShadowRadius: CGFloat = 12

    /// Vertical offset for card drop shadow
    static let cardShadowYOffset: CGFloat = 4

    // MARK: - Navigation

    /// Horizontal safe-area inset for full-bleed cards
    static let horizontalPageInset: CGFloat = 16

    // MARK: - Tags / Badges

    /// Horizontal padding inside a skill/tech tag
    static let tagHorizontalPadding: CGFloat = 10

    /// Vertical padding inside a skill/tech tag
    static let tagVerticalPadding: CGFloat = 4

    /// Corner radius for tag pills
    static let tagCornerRadius: CGFloat = 8
}
