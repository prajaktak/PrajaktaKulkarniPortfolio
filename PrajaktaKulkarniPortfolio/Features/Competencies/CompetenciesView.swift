// CompetenciesView.swift
// PrajaktaKulkarniPortfolio
//
// Displays competencies as a sorted list of titled descriptions,
// followed by a languages section showing speaking and writing proficiency.

import SwiftUI

/// Displays the Competencies & Languages card.
/// Shows competencies sorted by orderIndex, then language proficiencies.
struct CompetenciesView: View {

    // MARK: - State

    @State private var viewModel = CompetenciesViewModel()

    // MARK: - Body

    var body: some View {
        ScrollView {
            Group {
                switch viewModel.viewState {
                case .idle, .loading:
                    loadingContent
                case .loaded:
                    loadedContent
                case .empty:
                    emptyContent
                case .error(let message):
                    errorContent(message: message)
                }
            }
        }
        .task {
            await viewModel.loadContent()
        }
    }

    // MARK: - Loading State

    private var loadingContent: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
            ForEach(0..<3, id: \.self) { _ in
                skeletonRow
            }
        }
        .padding(ThemeSpacing.cardPadding)
        .accessibilityLabel("Loading competencies")
    }

    private var skeletonRow: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.extraSmall) {
            RoundedRectangle(cornerRadius: 6)
                .fill(ThemeColor.secondaryBackground)
                .frame(width: 140, height: 16)
                .opacity(0.6)
            RoundedRectangle(cornerRadius: 6)
                .fill(ThemeColor.secondaryBackground)
                .frame(maxWidth: .infinity, minHeight: 12, maxHeight: 12)
                .opacity(0.4)
        }
    }

    // MARK: - Loaded State

    private var loadedContent: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.large) {
            if !viewModel.competencies.isEmpty {
                competenciesSection
            }
            if !viewModel.languages.isEmpty {
                languagesSection
            }
        }
        .padding(ThemeSpacing.cardPadding)
    }

    // MARK: - Competencies Section

    private var competenciesSection: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
            sectionHeader(title: "Competencies", iconName: "brain.head.profile")

            ForEach(viewModel.competencies, id: \.id) { competency in
                competencyRow(competency: competency)
            }
        }
    }

    private func competencyRow(competency: Competency) -> some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.extraSmall) {
            Text(competency.competencyTitle)
                .font(ThemeFont.subheading)
                .foregroundStyle(ThemeColor.primaryText)

            Text(competency.competencyDescription)
                .font(ThemeFont.bodySmall)
                .foregroundStyle(ThemeColor.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(competency.competencyTitle): \(competency.competencyDescription)")
    }

    // MARK: - Languages Section

    private var languagesSection: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
            sectionHeader(title: "Languages", iconName: "globe")

            ForEach(viewModel.languages, id: \.id) { language in
                languageRow(language: language)
            }
        }
    }

    private func languageRow(language: Language) -> some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.extraSmall) {
            Text(language.languageName)
                .font(ThemeFont.subheading)
                .foregroundStyle(ThemeColor.primaryText)

            HStack(spacing: ThemeSpacing.small) {
                proficiencyChip(label: "Speaking", value: language.speakingProficiency)
                proficiencyChip(label: "Writing", value: language.writingProficiency)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "\(language.languageName), speaking: \(language.speakingProficiency), writing: \(language.writingProficiency)"
        )
    }

    private func proficiencyChip(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(size: 9, weight: .regular))
                .foregroundStyle(ThemeColor.tertiaryText)
            Text(value)
                .font(ThemeFont.tagLabel)
                .foregroundStyle(ThemeColor.accentPrimary)
        }
        .padding(.horizontal, ThemeSpacing.tagHorizontalPadding)
        .padding(.vertical, ThemeSpacing.tagVerticalPadding)
        .background(ThemeColor.tagBackground)
        .clipShape(RoundedRectangle(cornerRadius: ThemeSpacing.tagCornerRadius))
    }

    // MARK: - Section Header

    private func sectionHeader(title: String, iconName: String) -> some View {
        HStack(spacing: ThemeSpacing.small) {
            Image(systemName: iconName)
                .font(ThemeFont.bodySmall)
                .foregroundStyle(ThemeColor.accentPrimary)
                .accessibilityHidden(true)
            Text(title)
                .font(ThemeFont.cardTitle)
                .foregroundStyle(ThemeColor.primaryText)
        }
        .accessibilityAddTraits(.isHeader)
    }

    // MARK: - Empty State

    private var emptyContent: some View {
        VStack(spacing: ThemeSpacing.medium) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 36))
                .foregroundStyle(ThemeColor.secondaryText)
                .accessibilityHidden(true)
            Text("No competencies listed yet")
                .font(ThemeFont.bodyText)
                .foregroundStyle(ThemeColor.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(ThemeSpacing.cardPadding)
    }

    // MARK: - Error State

    private func errorContent(message: String) -> some View {
        VStack(spacing: ThemeSpacing.medium) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 36))
                .foregroundStyle(ThemeColor.accentSecondary)
                .accessibilityHidden(true)

            Text("Could not load competencies")
                .font(ThemeFont.cardTitle)
                .foregroundStyle(ThemeColor.primaryText)

            Text(message)
                .font(ThemeFont.captionText)
                .foregroundStyle(ThemeColor.secondaryText)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task { await viewModel.loadContent() }
            }
            .font(ThemeFont.bodySmall)
            .foregroundStyle(ThemeColor.accentPrimary)
        }
        .padding(ThemeSpacing.cardPadding)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview

#Preview("Competencies Card") {
    ScrollView {
        CompetenciesView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
}

#Preview("Competencies Card - Dark") {
    ScrollView {
        CompetenciesView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
    .preferredColorScheme(.dark)
}
