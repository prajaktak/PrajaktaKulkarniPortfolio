// SkillsView.swift
// PrajaktaKulkarniPortfolio
//
// Displays skills grouped by category as a flow of tag chips.
// Each category has a heading followed by a wrapping row of skill tags.

import SwiftUI

/// Displays the Skills card with skills grouped by category.
struct SkillsView: View {

    // MARK: - State

    @State private var viewModel = SkillsViewModel()

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
            await viewModel.loadSkills()
        }
    }

    // MARK: - Loading State

    private var loadingContent: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.large) {
            ForEach(0..<3, id: \.self) { _ in
                skeletonCategory
            }
        }
        .padding(ThemeSpacing.cardPadding)
        .accessibilityLabel("Loading skills")
    }

    private var skeletonCategory: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
            skeletonRow(width: 120, height: 16)
            HStack(spacing: ThemeSpacing.small) {
                skeletonRow(width: 60, height: 28)
                skeletonRow(width: 80, height: 28)
                skeletonRow(width: 50, height: 28)
            }
        }
    }

    private func skeletonRow(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(ThemeColor.secondaryBackground)
            .frame(width: width, height: height)
            .opacity(0.6)
    }

    // MARK: - Loaded State

    private var loadedContent: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.large) {
            ForEach(viewModel.sortedCategories, id: \.self) { category in
                categorySection(category: category)
            }
        }
        .padding(ThemeSpacing.cardPadding)
    }

    private func categorySection(category: String) -> some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
            Text(category)
                .font(ThemeFont.cardTitle)
                .foregroundStyle(ThemeColor.primaryText)
                .accessibilityAddTraits(.isHeader)

            skillTagsFlow(skills: viewModel.groupedSkills[category] ?? [])
        }
    }

    private func skillTagsFlow(skills: [Skill]) -> some View {
        // FlowLayout-style wrapping using LazyVGrid with adaptive columns
        let columns = [GridItem(.adaptive(minimum: 80), spacing: ThemeSpacing.small)]
        return LazyVGrid(columns: columns, alignment: .leading, spacing: ThemeSpacing.small) {
            ForEach(skills, id: \.id) { skill in
                skillTag(skill: skill)
            }
        }
    }

    private func skillTag(skill: Skill) -> some View {
        VStack(spacing: 2) {
            Text(skill.skillName)
                .font(ThemeFont.tagLabel)
                .foregroundStyle(ThemeColor.accentPrimary)

            if let level = skill.proficiencyLevel {
                Text(level)
                    .font(.system(size: 9, weight: .regular))
                    .foregroundStyle(ThemeColor.tertiaryText)
            }
        }
        .padding(.horizontal, ThemeSpacing.tagHorizontalPadding)
        .padding(.vertical, ThemeSpacing.tagVerticalPadding)
        .frame(maxWidth: .infinity)
        .background(ThemeColor.tagBackground)
        .clipShape(RoundedRectangle(cornerRadius: ThemeSpacing.tagCornerRadius))
        .accessibilityLabel(skill.proficiencyLevel.map { "\(skill.skillName), \($0)" } ?? skill.skillName)
    }

    // MARK: - Empty State

    private var emptyContent: some View {
        VStack(spacing: ThemeSpacing.medium) {
            Image(systemName: "star")
                .font(.system(size: 36))
                .foregroundStyle(ThemeColor.secondaryText)
                .accessibilityHidden(true)
            Text("No skills listed yet")
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

            Text("Could not load skills")
                .font(ThemeFont.cardTitle)
                .foregroundStyle(ThemeColor.primaryText)

            Text(message)
                .font(ThemeFont.captionText)
                .foregroundStyle(ThemeColor.secondaryText)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task { await viewModel.loadSkills() }
            }
            .font(ThemeFont.bodySmall)
            .foregroundStyle(ThemeColor.accentPrimary)
        }
        .padding(ThemeSpacing.cardPadding)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview

#Preview("Skills Card") {
    CardView(section: CardSection.allPortfolioSections[2]) {
        SkillsView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
}

#Preview("Skills Card - Dark") {
    CardView(section: CardSection.allPortfolioSections[2]) {
        SkillsView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
    .preferredColorScheme(.dark)
}
