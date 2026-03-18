// ProjectsView.swift
// PrajaktaKulkarniPortfolio
//
// Displays projects as horizontally swipeable pages, sorted by orderIndex.
// The featured project shows a special badge. Each page shows the project's
// title, date range, description, tech stack, and GitHub link.

import SwiftUI

/// Displays the Projects card with each project as a swipeable page.
struct ProjectsView: View {

    // MARK: - State

    @State private var viewModel = ProjectsViewModel()
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
            await viewModel.loadProjects()
        }
    }

    // MARK: - Loading State

    private var loadingContent: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
            RoundedRectangle(cornerRadius: ThemeSpacing.cardCornerRadius / 2)
                .fill(ThemeColor.secondaryBackground)
                .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 140)
                .opacity(0.6)

            ForEach(0..<2, id: \.self) { _ in
                skeletonProjectRow
            }
        }
        .accessibilityLabel("Loading projects")
    }

    private var skeletonProjectRow: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.extraSmall) {
            RoundedRectangle(cornerRadius: 6)
                .fill(ThemeColor.secondaryBackground)
                .frame(width: 180, height: 16)
                .opacity(0.6)
            RoundedRectangle(cornerRadius: 6)
                .fill(ThemeColor.secondaryBackground)
                .frame(width: 100, height: 12)
                .opacity(0.4)
        }
    }

    // MARK: - Loaded State

    private var loadedContent: some View {
        VStack(spacing: ThemeSpacing.small) {
            TabView(selection: $currentPage) {
                ForEach(Array(viewModel.projects.enumerated()), id: \.element.id) { index, project in
                    ScrollView {
                        projectPage(project: project)
                            .padding(ThemeSpacing.cardPadding)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentPage)
            .frame(maxHeight: .infinity)

            // Dot page indicator
            if viewModel.projects.count > 1 {
                pageIndicator
                    .padding(.bottom, ThemeSpacing.small)
            }
        }
    }

    private func projectPage(project: Project) -> some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
            // Title + featured badge
            HStack(alignment: .top, spacing: ThemeSpacing.small) {
                Text(project.title)
                    .font(ThemeFont.cardTitle)
                    .foregroundStyle(ThemeColor.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                if project.isFeatured {
                    featuredBadge
                }
            }

            // Date / ongoing badge
            if project.isOngoing {
                ongoingBadge
            } else {
                Text(dateRangeText(for: project))
                    .font(ThemeFont.captionText)
                    .foregroundStyle(ThemeColor.secondaryText)
            }

            Divider()
                .background(ThemeColor.divider)

            // Description
            Text(project.projectDescription)
                .font(ThemeFont.bodySmall)
                .foregroundStyle(ThemeColor.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            // Tech stack tags
            if !project.techStack.isEmpty {
                techStackFlow(tags: project.techStack)
            }

            // GitHub button
            if let githubURLString = project.githubURL, let url = URL(string: githubURLString) {
                githubButton(url: url)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel(for: project))
    }

    // MARK: - Page Indicator

    private var pageIndicator: some View {
        HStack(spacing: ThemeSpacing.small) {
            ForEach(0..<viewModel.projects.count, id: \.self) { dotIndex in
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
        .accessibilityLabel("Project \(currentPage + 1) of \(viewModel.projects.count)")
    }

    // MARK: - Tech Stack Tags

    private func techStackFlow(tags: [String]) -> some View {
        let columns = [GridItem(.adaptive(minimum: 70), spacing: ThemeSpacing.small)]
        return LazyVGrid(columns: columns, alignment: .leading, spacing: ThemeSpacing.small) {
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

    // MARK: - GitHub Button

    private func githubButton(url: URL) -> some View {
        Link(destination: url) {
            HStack(spacing: ThemeSpacing.extraSmall) {
                Image(systemName: "arrow.up.right.square")
                    .font(ThemeFont.captionText)
                    .accessibilityHidden(true)
                Text("View on GitHub")
                    .font(ThemeFont.captionText)
            }
            .foregroundStyle(ThemeColor.accentPrimary)
        }
        .accessibilityLabel("View project on GitHub")
        .accessibilityHint("Opens GitHub in browser")
    }

    // MARK: - Badges

    private var featuredBadge: some View {
        HStack(spacing: ThemeSpacing.extraSmall) {
            Image(systemName: "star.fill")
                .font(.system(size: 9))
                .accessibilityHidden(true)
            Text("Featured")
                .font(ThemeFont.tagLabel)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, ThemeSpacing.tagHorizontalPadding)
        .padding(.vertical, ThemeSpacing.tagVerticalPadding)
        .background(ThemeColor.accentPrimary)
        .clipShape(Capsule())
    }

    private var ongoingBadge: some View {
        Text("Ongoing")
            .font(ThemeFont.tagLabel)
            .foregroundStyle(ThemeColor.success)
            .padding(.horizontal, ThemeSpacing.tagHorizontalPadding)
            .padding(.vertical, ThemeSpacing.tagVerticalPadding)
            .background(ThemeColor.success.opacity(0.15))
            .clipShape(Capsule())
    }

    // MARK: - Empty State

    private var emptyContent: some View {
        VStack(spacing: ThemeSpacing.medium) {
            Image(systemName: "folder")
                .font(.system(size: 36))
                .foregroundStyle(ThemeColor.secondaryText)
                .accessibilityHidden(true)
            Text("No projects listed yet")
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

            Text("Could not load projects")
                .font(ThemeFont.cardTitle)
                .foregroundStyle(ThemeColor.primaryText)

            Text(message)
                .font(ThemeFont.captionText)
                .foregroundStyle(ThemeColor.secondaryText)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task { await viewModel.loadProjects() }
            }
            .font(ThemeFont.bodySmall)
            .foregroundStyle(ThemeColor.accentPrimary)
        }
        .accessibilityElement(children: .combine)
    }

    // MARK: - Helpers

    private func dateRangeText(for project: Project) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        let start = formatter.string(from: project.startDate)
        if let end = project.endDate {
            return "\(start) – \(formatter.string(from: end))"
        }
        return "\(start) – Present"
    }

    private func accessibilityLabel(for project: Project) -> String {
        var label = project.title
        if project.isOngoing {
            label += ", ongoing"
        } else {
            label += ", \(dateRangeText(for: project))"
        }
        label += ". \(project.projectDescription)"
        return label
    }
}

// MARK: - Preview

#Preview("Projects Card") {
    CardView(section: CardSection.allPortfolioSections[6]) {
        ProjectsView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
}

#Preview("Projects Card - Dark") {
    CardView(section: CardSection.allPortfolioSections[6]) {
        ProjectsView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
    .preferredColorScheme(.dark)
}
