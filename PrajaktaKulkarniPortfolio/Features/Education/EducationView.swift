// EducationView.swift
// PrajaktaKulkarniPortfolio
//
// Displays education entries as cards showing degree, field, institution,
// date range, diploma status, and subjects studied.

import SwiftUI

/// Displays the Education card with a list of education entries.
struct EducationView: View {

    // MARK: - State

    @State private var viewModel = EducationViewModel()

    // MARK: - Body

    var body: some View {
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
        .task {
            await viewModel.loadEducation()
        }
    }

    // MARK: - Loading State

    private var loadingContent: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.large) {
            ForEach(0..<2, id: \.self) { _ in
                skeletonEntry
            }
        }
        .padding(ThemeSpacing.cardPadding)
        .accessibilityLabel("Loading education")
    }

    private var skeletonEntry: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
            skeletonRow(width: 200, height: 18)
            skeletonRow(width: 160, height: 14)
            skeletonRow(width: 120, height: 12)
            skeletonRow(width: .infinity, height: 12)
        }
        .padding(ThemeSpacing.medium)
        .background(ThemeColor.secondaryBackground.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: ThemeSpacing.cardCornerRadius / 2))
    }

    private func skeletonRow(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(ThemeColor.secondaryBackground)
            .frame(maxWidth: width == .infinity ? .infinity : width, minHeight: height, maxHeight: height)
            .opacity(0.6)
    }

    // MARK: - Loaded State

    private var loadedContent: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
            ForEach(viewModel.educationEntries, id: \.id) { entry in
                educationCard(entry: entry)
            }
        }
        .padding(ThemeSpacing.cardPadding)
    }

    private func educationCard(entry: Education) -> some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
            // Degree + diploma badge
            HStack(alignment: .top) {
                Text(entry.degreeName)
                    .font(ThemeFont.cardTitle)
                    .foregroundStyle(ThemeColor.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                if entry.hasDiploma {
                    diplomaBadge
                }
            }

            // Field of study
            Text(entry.fieldOfStudy)
                .font(ThemeFont.subheading)
                .foregroundStyle(ThemeColor.accentPrimary)

            // Institution
            HStack(spacing: ThemeSpacing.extraSmall) {
                Image(systemName: "building.columns.fill")
                    .font(ThemeFont.captionText)
                    .foregroundStyle(ThemeColor.secondaryText)
                    .accessibilityHidden(true)
                Text(entry.institutionName)
                    .font(ThemeFont.bodySmall)
                    .foregroundStyle(ThemeColor.secondaryText)
            }

            // Date range
            HStack(spacing: ThemeSpacing.extraSmall) {
                Image(systemName: "calendar")
                    .font(ThemeFont.captionText)
                    .foregroundStyle(ThemeColor.secondaryText)
                    .accessibilityHidden(true)
                Text(dateRangeText(for: entry))
                    .font(ThemeFont.captionText)
                    .foregroundStyle(ThemeColor.secondaryText)
            }

            // Subjects
            if !entry.subjectsStudied.isEmpty {
                Divider().background(ThemeColor.divider)
                Text("Subjects")
                    .font(ThemeFont.captionText)
                    .foregroundStyle(ThemeColor.tertiaryText)
                Text(entry.subjectsStudied)
                    .font(ThemeFont.bodySmall)
                    .foregroundStyle(ThemeColor.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(ThemeSpacing.medium)
        .background(ThemeColor.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: ThemeSpacing.cardCornerRadius / 2))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel(for: entry))
    }

    private var diplomaBadge: some View {
        HStack(spacing: ThemeSpacing.extraSmall) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 10))
                .accessibilityHidden(true)
            Text("Diploma")
                .font(ThemeFont.tagLabel)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, ThemeSpacing.tagHorizontalPadding)
        .padding(.vertical, ThemeSpacing.tagVerticalPadding)
        .background(ThemeColor.accentPrimary)
        .clipShape(Capsule())
    }

    // MARK: - Empty State

    private var emptyContent: some View {
        VStack(spacing: ThemeSpacing.medium) {
            Image(systemName: "graduationcap")
                .font(.system(size: 36))
                .foregroundStyle(ThemeColor.secondaryText)
                .accessibilityHidden(true)
            Text("No education listed yet")
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

            Text("Could not load education")
                .font(ThemeFont.cardTitle)
                .foregroundStyle(ThemeColor.primaryText)

            Text(message)
                .font(ThemeFont.captionText)
                .foregroundStyle(ThemeColor.secondaryText)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task { await viewModel.loadEducation() }
            }
            .font(ThemeFont.bodySmall)
            .foregroundStyle(ThemeColor.accentPrimary)
        }
        .padding(ThemeSpacing.cardPadding)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Helpers

    private func dateRangeText(for entry: Education) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return "\(formatter.string(from: entry.startDate)) – \(formatter.string(from: entry.endDate))"
    }

    private func accessibilityLabel(for entry: Education) -> String {
        "\(entry.degreeName) in \(entry.fieldOfStudy) at \(entry.institutionName), \(dateRangeText(for: entry))"
    }
}

// MARK: - Preview

#Preview("Education Card") {
    CardView(section: CardSection.allPortfolioSections[3]) {
        EducationView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
}

#Preview("Education Card - Dark") {
    CardView(section: CardSection.allPortfolioSections[3]) {
        EducationView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
    .preferredColorScheme(.dark)
}
