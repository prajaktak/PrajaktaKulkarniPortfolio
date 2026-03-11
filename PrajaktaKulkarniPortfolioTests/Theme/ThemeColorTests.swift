// ThemeColorTests.swift
// PrajaktaKulkarniPortfolioTests
//
// Tests for ThemeColor design system.
// Verifies that all semantic color tokens are accessible and non-nil.

import Testing
import SwiftUI
@testable import PrajaktaKulkarniPortfolio

@Suite("ThemeColor Tests")
struct ThemeColorTests {

    @Test("primaryBackground is accessible")
    func primaryBackground_isAccessible() {
        let color = ThemeColor.primaryBackground
        #expect(color != Color.clear)
    }

    @Test("secondaryBackground is accessible")
    func secondaryBackground_isAccessible() {
        let color = ThemeColor.secondaryBackground
        #expect(color != Color.clear)
    }

    @Test("cardBackground is accessible")
    func cardBackground_isAccessible() {
        let color = ThemeColor.cardBackground
        #expect(color != Color.clear)
    }

    @Test("primaryText is accessible")
    func primaryText_isAccessible() {
        let color = ThemeColor.primaryText
        #expect(color != Color.clear)
    }

    @Test("secondaryText is accessible")
    func secondaryText_isAccessible() {
        let color = ThemeColor.secondaryText
        #expect(color != Color.clear)
    }

    @Test("accentPrimary is accessible")
    func accentPrimary_isAccessible() {
        let color = ThemeColor.accentPrimary
        #expect(color != Color.clear)
    }

    @Test("accentSecondary is accessible")
    func accentSecondary_isAccessible() {
        let color = ThemeColor.accentSecondary
        #expect(color != Color.clear)
    }

    @Test("cardShadow is accessible")
    func cardShadow_isAccessible() {
        let color = ThemeColor.cardShadow
        #expect(color != Color.clear)
    }

    @Test("divider is accessible")
    func divider_isAccessible() {
        let color = ThemeColor.divider
        #expect(color != Color.clear)
    }
}

@Suite("ThemeFont Tests")
struct ThemeFontTests {

    @Test("heroTitle returns a font")
    func heroTitle_returnsFont() {
        let font = ThemeFont.heroTitle
        #expect(font != Font.body)
    }

    @Test("sectionTitle returns a font")
    func sectionTitle_returnsFont() {
        let font = ThemeFont.sectionTitle
        #expect(font != Font.body)
    }

    @Test("cardTitle returns a font")
    func cardTitle_returnsFont() {
        let font = ThemeFont.cardTitle
        #expect(font != Font.body)
    }

    @Test("bodyText returns a font")
    func bodyText_returnsFont() {
        let font = ThemeFont.bodyText
        #expect(font != Font.caption)
    }

    @Test("captionText returns a font")
    func captionText_returnsFont() {
        let font = ThemeFont.captionText
        #expect(font != Font.title)
    }

    @Test("tagLabel returns a font")
    func tagLabel_returnsFont() {
        let font = ThemeFont.tagLabel
        #expect(font != Font.title)
    }
}

@Suite("ThemeSpacing Tests")
struct ThemeSpacingTests {

    @Test("extraSmall is positive")
    func extraSmall_isPositive() {
        #expect(ThemeSpacing.extraSmall > 0)
    }

    @Test("small is greater than extraSmall")
    func small_isGreaterThanExtraSmall() {
        #expect(ThemeSpacing.small > ThemeSpacing.extraSmall)
    }

    @Test("medium is greater than small")
    func medium_isGreaterThanSmall() {
        #expect(ThemeSpacing.medium > ThemeSpacing.small)
    }

    @Test("large is greater than medium")
    func large_isGreaterThanMedium() {
        #expect(ThemeSpacing.large > ThemeSpacing.medium)
    }

    @Test("extraLarge is greater than large")
    func extraLarge_isGreaterThanLarge() {
        #expect(ThemeSpacing.extraLarge > ThemeSpacing.large)
    }

    @Test("cardPadding is positive")
    func cardPadding_isPositive() {
        #expect(ThemeSpacing.cardPadding > 0)
    }

    @Test("cardCornerRadius is positive")
    func cardCornerRadius_isPositive() {
        #expect(ThemeSpacing.cardCornerRadius > 0)
    }
}
