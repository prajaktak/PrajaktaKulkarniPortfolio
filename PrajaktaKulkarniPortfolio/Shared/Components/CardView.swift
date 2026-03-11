// CardView.swift
// PrajaktaKulkarniPortfolio
//
// Reusable full-screen card shell used by every portfolio section.
// Accepts any SwiftUI content via a generic ViewBuilder closure,
// applying consistent background, shadow, padding, and corner radius
// from the ThemeColor and ThemeSpacing design tokens.

import SwiftUI

/// A full-screen card container used as the shell for every portfolio section.
/// Content is provided via a generic ViewBuilder, keeping this view single-responsibility.
struct CardView<Content: View>: View {

    // MARK: - Properties

    let section: CardSection
    private let content: Content

    // MARK: - Init

    init(section: CardSection, @ViewBuilder content: () -> Content) {
        self.section = section
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Card background surface
            RoundedRectangle(cornerRadius: ThemeSpacing.cardCornerRadius)
                .fill(ThemeColor.cardBackground)
                .shadow(
                    color: ThemeColor.cardShadow,
                    radius: ThemeSpacing.cardShadowRadius,
                    x: 0,
                    y: ThemeSpacing.cardShadowYOffset
                )

            // Card content
            VStack(alignment: .leading, spacing: 0) {
                cardHeader
                    .padding(.bottom, ThemeSpacing.medium)

                Divider()
                    .background(ThemeColor.divider)

                ScrollView {
                    content
                        .padding(ThemeSpacing.cardPadding)
                }
            }
            .padding(ThemeSpacing.cardPadding)
        }
        .padding(.horizontal, ThemeSpacing.horizontalPageInset)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(section.title)
    }

    // MARK: - Private Views

    private var cardHeader: some View {
        HStack(spacing: ThemeSpacing.small) {
            Image(systemName: section.iconName)
                .font(ThemeFont.cardTitle)
                .foregroundStyle(ThemeColor.accentPrimary)
                .accessibilityHidden(true)

            Text(section.title)
                .font(ThemeFont.sectionTitle)
                .foregroundStyle(ThemeColor.primaryText)
                .accessibilityAddTraits(.isHeader)
        }
    }
}

// MARK: - Preview

#Preview("Welcome Card") {
    CardView(section: CardSection.allPortfolioSections[0]) {
        VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
            Text("Prajakta Kulkarni")
                .font(ThemeFont.heroTitle)
            Text("iOS Developer")
                .font(ThemeFont.subheading)
                .foregroundStyle(ThemeColor.secondaryText)
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
}

#Preview("Experience Card") {
    CardView(section: CardSection.allPortfolioSections[1]) {
        Text("Work experience content goes here")
            .foregroundStyle(ThemeColor.secondaryText)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
}
