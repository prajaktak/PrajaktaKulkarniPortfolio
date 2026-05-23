// WorkExperienceView.swift
// PrajaktaKulkarniPortfolio
//
// Displays work experience entries as horizontally swipeable pages.
// Each entry is its own page showing company, job title, dates, hours/week,
// description, and tech tags. A dot indicator shows current position.

import SwiftUI

/// Displays the Work Experience card with each job entry as a swipeable page.
struct WorkExperienceView: View {

    // MARK: - State

    @State private var viewModel = WorkExperienceViewModel()
    @State private var currentPage: Int = 0

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
        VStack(spacing: ThemeSpacing.small) {
            TabView(selection: $currentPage) {
                ForEach(Array(viewModel.experiences.enumerated()), id: \.element.id) { index, experience in
                    ScrollView {
                        experiencePage(experience: experience)
                            .padding(ThemeSpacing.cardPadding)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentPage)
            .frame(maxHeight: .infinity)

            // Dot page indicator
            if viewModel.experiences.count > 1 {
                pageIndicator
                    .padding(.bottom, ThemeSpacing.small)
            }
        }
    }

    private func experiencePage(experience: WorkExperience) -> some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
            // Job title + current badge
            HStack(alignment: .top) {
                Text(experience.jobTitle)
                    .font(ThemeFont.cardTitle)
                    .foregroundStyle(ThemeColor.primaryText)

                if experience.isCurrentPosition {
                    currentBadge
                }
            }

            // Company
            Text(experience.companyName)
                .font(ThemeFont.subheading)
                .foregroundStyle(ThemeColor.accentPrimary)

            // Date range + hours
            VStack(alignment: .leading, spacing: ThemeSpacing.extraSmall) {
                Text(dateRangeText(for: experience))
                    .font(ThemeFont.captionText)
                    .foregroundStyle(ThemeColor.secondaryText)

                Text("\(experience.hoursPerWeek) hrs/week")
                    .font(ThemeFont.captionText)
                    .foregroundStyle(ThemeColor.tertiaryText)
            }

            Divider()
                .background(ThemeColor.divider)

            // Description
            Text(experience.jobDescription)
                .font(ThemeFont.bodySmall)
                .foregroundStyle(ThemeColor.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            // Tech tags
            if !experience.technologiesUsed.isEmpty {
                techTagsRow(tags: experience.technologiesUsed)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel(for: experience))
    }

    // MARK: - Page Indicator

    private var pageIndicator: some View {
        HStack(spacing: ThemeSpacing.small) {
            ForEach(0..<viewModel.experiences.count, id: \.self) { dotIndex in
                Circle()
                    .fill(dotIndex == currentPage
                          ? ThemeColor.accentPrimary
                          : ThemeColor.secondaryText.opacity(0.4))
                    .frame(
                        width: dotIndex == currentPage ? 8 : 5,
                        height: dotIndex == currentPage ? 8 : 5
                    )
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                    .accessibilityHidden(true)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Experience \(currentPage + 1) of \(viewModel.experiences.count)")
    }

    // MARK: - Badges

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
        .accessibilityElement(children: .combine)
    }

    // MARK: - Helpers

    private func dateRangeText(for experience: WorkExperience) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        let startText = formatter.string(from: experience.startDate)
        let endText = experience.endDate.map { formatter.string(from: $0) } ?? String(localized: "Present")
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
