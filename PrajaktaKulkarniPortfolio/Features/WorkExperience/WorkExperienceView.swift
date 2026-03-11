// WorkExperienceView.swift
// PrajaktaKulkarniPortfolio
//
// Displays all work experience entries as a vertical timeline.
// Each entry shows company, job title, dates, hours/week, description, and tech tags.

import SwiftUI

/// Displays the Work Experience card with a timeline of job entries.
struct WorkExperienceView: View {

    // MARK: - State

    @State private var viewModel = WorkExperienceViewModel()

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
            await viewModel.loadExperiences()
        }
    }

    // MARK: - Loading State

    private var loadingContent: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.large) {
            ForEach(0..<3, id: \.self) { _ in
                skeletonEntry
            }
        }
        .padding(ThemeSpacing.cardPadding)
        .accessibilityLabel("Loading work experience")
    }

    private var skeletonEntry: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
            skeletonRow(width: 180, height: 18)
            skeletonRow(width: 140, height: 14)
            skeletonRow(width: .infinity, height: 12)
            skeletonRow(width: 260, height: 12)
        }
    }

    private func skeletonRow(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(ThemeColor.secondaryBackground)
            .frame(maxWidth: width == .infinity ? .infinity : width, minHeight: height, maxHeight: height)
            .opacity(0.6)
    }

    // MARK: - Loaded State

    private var loadedContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(viewModel.experiences.enumerated()), id: \.element.id) { entryIndex, experience in
                timelineEntry(experience: experience, isLast: entryIndex == viewModel.experiences.count - 1)
            }
        }
        .padding(ThemeSpacing.cardPadding)
    }

    private func timelineEntry(experience: WorkExperience, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: ThemeSpacing.medium) {
            timelineDot(isCurrent: experience.isCurrentPosition, isLast: isLast)
            experienceDetail(experience: experience)
                .padding(.bottom, isLast ? 0 : ThemeSpacing.large)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel(for: experience))
    }

    private func timelineDot(isCurrent: Bool, isLast: Bool) -> some View {
        VStack(spacing: 0) {
            Circle()
                .fill(isCurrent ? ThemeColor.accentPrimary : ThemeColor.secondaryText.opacity(0.4))
                .frame(width: 12, height: 12)
                .padding(.top, 4)

            if !isLast {
                Rectangle()
                    .fill(ThemeColor.divider)
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }
        }
        .frame(width: 12)
        .accessibilityHidden(true)
    }

    private func experienceDetail(experience: WorkExperience) -> some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
            // Job title + current badge
            HStack(alignment: .top) {
                Text(experience.jobTitle)
                    .font(ThemeFont.cardTitle)
                    .foregroundStyle(ThemeColor.primaryText)

                if experience.isCurrentPosition {
                    currentBadge
                }
            }

            // Company + dates
            Text(experience.companyName)
                .font(ThemeFont.subheading)
                .foregroundStyle(ThemeColor.accentPrimary)

            Text(dateRangeText(for: experience))
                .font(ThemeFont.captionText)
                .foregroundStyle(ThemeColor.secondaryText)

            // Hours per week
            Text("\(experience.hoursPerWeek) hrs/week")
                .font(ThemeFont.captionText)
                .foregroundStyle(ThemeColor.tertiaryText)

            // Description
            Text(experience.jobDescription)
                .font(ThemeFont.bodySmall)
                .foregroundStyle(ThemeColor.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            // Tech tags
            if !experience.technologiesUsed.isEmpty {
                techTagsRow(tags: experience.technologiesUsed)
            }
        }
    }

    private var currentBadge: some View {
        Text("Current")
            .font(ThemeFont.tagLabel)
            .foregroundStyle(.white)
            .padding(.horizontal, ThemeSpacing.tagHorizontalPadding)
            .padding(.vertical, ThemeSpacing.tagVerticalPadding)
            .background(ThemeColor.success)
            .clipShape(Capsule())
    }

    private func techTagsRow(tags: [String]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: ThemeSpacing.small) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(ThemeFont.tagLabel)
                        .foregroundStyle(ThemeColor.accentPrimary)
                        .padding(.horizontal, ThemeSpacing.tagHorizontalPadding)
                        .padding(.vertical, ThemeSpacing.tagVerticalPadding)
                        .background(ThemeColor.tagBackground)
                        .clipShape(RoundedRectangle(cornerRadius: ThemeSpacing.tagCornerRadius))
                }
            }
        }
    }

    // MARK: - Empty State

    private var emptyContent: some View {
        VStack(spacing: ThemeSpacing.medium) {
            Image(systemName: "briefcase")
                .font(.system(size: 36))
                .foregroundStyle(ThemeColor.secondaryText)
                .accessibilityHidden(true)
            Text("No experience listed yet")
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

            Text("Could not load experience")
                .font(ThemeFont.cardTitle)
                .foregroundStyle(ThemeColor.primaryText)

            Text(message)
                .font(ThemeFont.captionText)
                .foregroundStyle(ThemeColor.secondaryText)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task { await viewModel.loadExperiences() }
            }
            .font(ThemeFont.bodySmall)
            .foregroundStyle(ThemeColor.accentPrimary)
        }
        .padding(ThemeSpacing.cardPadding)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Helpers

    private func dateRangeText(for experience: WorkExperience) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        let startText = formatter.string(from: experience.startDate)
        let endText = experience.endDate.map { formatter.string(from: $0) } ?? "Present"
        return "\(startText) – \(endText)"
    }

    private func accessibilityLabel(for experience: WorkExperience) -> String {
        "\(experience.jobTitle) at \(experience.companyName), \(dateRangeText(for: experience))"
    }
}

// MARK: - Preview

#Preview("Work Experience Card") {
    CardView(section: CardSection.allPortfolioSections[1]) {
        WorkExperienceView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
}

#Preview("Work Experience Card - Dark") {
    CardView(section: CardSection.allPortfolioSections[1]) {
        WorkExperienceView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
    .preferredColorScheme(.dark)
}
