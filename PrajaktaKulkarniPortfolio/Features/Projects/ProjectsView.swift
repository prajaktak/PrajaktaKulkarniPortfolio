// ProjectsView.swift
// PrajaktaKulkarniPortfolio
//
// Displays projects sorted by orderIndex, with the featured project
// highlighted at the top. Each project shows title, date range,
// ongoing badge, description, tech stack tags, and a GitHub link button.

import SwiftUI

/// Displays the Projects card with a featured project highlight and full list.
struct ProjectsView: View {

    // MARK: - State

    @State private var viewModel = ProjectsViewModel()

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
            // Featured project skeleton
            RoundedRectangle(cornerRadius: ThemeSpacing.cardCornerRadius / 2)
                .fill(ThemeColor.secondaryBackground)
                .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 140)
                .opacity(0.6)

            ForEach(0..<2, id: \.self) { _ in
                skeletonProjectRow
            }
        }
        .padding(ThemeSpacing.cardPadding)
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
        VStack(alignment: .leading, spacing: ThemeSpacing.large) {
            // Featured project callout
            if let featured = viewModel.featuredProject {
                featuredProjectCard(project: featured)
            }

            // All projects list
            let otherProjects = viewModel.featuredProject == nil
                ? viewModel.projects
                : viewModel.projects.filter { $0.id != viewModel.featuredProject?.id }

            if !otherProjects.isEmpty {
                VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
                    if viewModel.featuredProject != nil {
                        Text("All Projects")
                            .font(ThemeFont.cardTitle)
                            .foregroundStyle(ThemeColor.primaryText)
                            .accessibilityAddTraits(.isHeader)
                    }

                    ForEach(otherProjects, id: \.id) { project in
                        projectRow(project: project)
                    }
                }
            }
        }
        .padding(ThemeSpacing.cardPadding)
    }

    // MARK: - Featured Project Card

    private func featuredProjectCard(project: Project) -> some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: ThemeSpacing.extraSmall) {
                    HStack(spacing: ThemeSpacing.small) {
                        Text(project.title)
                            .font(ThemeFont.cardTitle)
                            .foregroundStyle(ThemeColor.primaryText)
                        featuredBadge
                    }
                    if project.isOngoing {
                        ongoingBadge
                    } else {
                        Text(dateRangeText(for: project))
                            .font(ThemeFont.captionText)
                            .foregroundStyle(ThemeColor.secondaryText)
                    }
                }
                Spacer()
            }

            // Description
            Text(project.projectDescription)
                .font(ThemeFont.bodySmall)
                .foregroundStyle(ThemeColor.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(4)

            // Tech stack tags
            if !project.techStack.isEmpty {
                techStackFlow(tags: project.techStack)
            }

            // GitHub button
            if let githubURLString = project.githubURL, let url = URL(string: githubURLString) {
                githubButton(url: url)
            }
        }
        .padding(ThemeSpacing.medium)
        .background(ThemeColor.accentPrimary.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: ThemeSpacing.cardCornerRadius / 2))
        .overlay(
            RoundedRectangle(cornerRadius: ThemeSpacing.cardCornerRadius / 2)
                .strokeBorder(ThemeColor.accentPrimary.opacity(0.3), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel(for: project))
    }

    // MARK: - Project Row (non-featured)

    private func projectRow(project: Project) -> some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
            // Title and ongoing badge
            HStack(alignment: .top) {
                Text(project.title)
                    .font(ThemeFont.subheading)
                    .foregroundStyle(ThemeColor.primaryText)
                Spacer()
                if project.isOngoing {
                    ongoingBadge
                }
            }

            // Date range
            if !project.isOngoing {
                Text(dateRangeText(for: project))
                    .font(ThemeFont.captionText)
                    .foregroundStyle(ThemeColor.secondaryText)
            }

            // Description
            Text(project.projectDescription)
                .font(ThemeFont.bodySmall)
                .foregroundStyle(ThemeColor.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(3)

            // Tech stack tags
            if !project.techStack.isEmpty {
                techStackFlow(tags: project.techStack)
            }

            // GitHub button
            if let githubURLString = project.githubURL, let url = URL(string: githubURLString) {
                githubButton(url: url)
            }
        }
        .padding(ThemeSpacing.medium)
        .background(ThemeColor.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: ThemeSpacing.cardCornerRadius / 2))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel(for: project))
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
        .padding(ThemeSpacing.cardPadding)
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
        .padding(ThemeSpacing.cardPadding)
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
    ScrollView {
        ProjectsView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
}

#Preview("Projects Card - Dark") {
    ScrollView {
        ProjectsView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
    .preferredColorScheme(.dark)
}
