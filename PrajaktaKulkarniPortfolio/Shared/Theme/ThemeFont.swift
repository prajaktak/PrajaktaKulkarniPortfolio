// ThemeFont.swift
// PrajaktaKulkarniPortfolio
//
// Typography scale for the portfolio design system.
// Uses Dynamic Type-compatible font styles so text scales
// with user's accessibility settings.

import SwiftUI

/// Typography tokens for the entire app.
/// All font usage must come from ThemeFont for consistency and Dynamic Type support.
enum ThemeFont {

    // MARK: - Display

    /// Large hero text on the Welcome card
    static let heroTitle: Font = .system(.largeTitle, design: .rounded, weight: .bold)

    // MARK: - Headings

    /// Section/card header title
    static let sectionTitle: Font = .system(.title2, design: .rounded, weight: .semibold)

    /// Individual card title (e.g. job title, project name)
    static let cardTitle: Font = .system(.headline, design: .rounded, weight: .semibold)

    /// Sub-heading within a card
    static let subheading: Font = .system(.subheadline, design: .rounded, weight: .medium)

    // MARK: - Body

    /// Standard body copy
    static let bodyText: Font = .system(.body, design: .default, weight: .regular)

    /// Slightly smaller body text (descriptions, summaries)
    static let bodySmall: Font = .system(.callout, design: .default, weight: .regular)

    // MARK: - Supporting

    /// Captions, dates, metadata
    static let captionText: Font = .system(.caption, design: .default, weight: .regular)

    /// Small tag / badge labels
    static let tagLabel: Font = .system(.caption2, design: .rounded, weight: .medium)
}
