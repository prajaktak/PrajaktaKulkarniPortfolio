// InterestsView.swift
// PrajaktaKulkarniPortfolio
//
// Displays personal interests as a list of titled descriptions,
// each with an icon indicator, sorted by orderIndex.

import SwiftUI

/// Displays the Interests card with a list of personal interests.
struct InterestsView: View {

    // MARK: - State

    @State private var viewModel = InterestsViewModel()

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
            await viewModel.loadInterests()
        }
    }

    // MARK: - Loading State

    private var loadingContent: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
            ForEach(0..<4, id: \.self) { _ in
                skeletonRow
            }
        }
        .padding(ThemeSpacing.cardPadding)
        .accessibilityLabel("Loading interests")
    }

    private var skeletonRow: some View {
        HStack(spacing: ThemeSpacing.small) {
            RoundedRectangle(cornerRadius: 8)
                .fill(ThemeColor.secondaryBackground)
                .frame(width: 36, height: 36)
                .opacity(0.6)
            VStack(alignment: .leading, spacing: ThemeSpacing.extraSmall) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(ThemeColor.secondaryBackground)
                    .frame(width: 100, height: 14)
                    .opacity(0.6)
                RoundedRectangle(cornerRadius: 6)
                    .fill(ThemeColor.secondaryBackground)
                    .frame(maxWidth: .infinity, minHeight: 12, maxHeight: 12)
                    .opacity(0.4)
            }
        }
    }

    // MARK: - Loaded State

    private var loadedContent: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
            ForEach(viewModel.interests, id: \.id) { interest in
                interestRow(interest: interest)
            }
        }
        .padding(ThemeSpacing.cardPadding)
    }

    private func interestRow(interest: Interest) -> some View {
        HStack(alignment: .top, spacing: ThemeSpacing.medium) {
            // Accent dot indicator
            Circle()
                .fill(ThemeColor.accentPrimary)
                .frame(width: 8, height: 8)
                .padding(.top, 6)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: ThemeSpacing.extraSmall) {
                Text(interest.interestTitle)
                    .font(ThemeFont.subheading)
                    .foregroundStyle(ThemeColor.primaryText)

                Text(interest.interestDescription)
                    .font(ThemeFont.bodySmall)
                    .foregroundStyle(ThemeColor.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(interest.interestTitle): \(interest.interestDescription)")
    }

    // MARK: - Empty State

    private var emptyContent: some View {
        VStack(spacing: ThemeSpacing.medium) {
            Image(systemName: "heart")
                .font(.system(size: 36))
                .foregroundStyle(ThemeColor.secondaryText)
                .accessibilityHidden(true)
            Text("No interests listed yet")
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

            Text("Could not load interests")
                .font(ThemeFont.cardTitle)
                .foregroundStyle(ThemeColor.primaryText)

            Text(message)
                .font(ThemeFont.captionText)
                .foregroundStyle(ThemeColor.secondaryText)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task { await viewModel.loadInterests() }
            }
            .font(ThemeFont.bodySmall)
            .foregroundStyle(ThemeColor.accentPrimary)
        }
        .padding(ThemeSpacing.cardPadding)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview

#Preview("Interests Card") {
    ScrollView {
        InterestsView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
}

#Preview("Interests Card - Dark") {
    ScrollView {
        InterestsView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
    .preferredColorScheme(.dark)
}
