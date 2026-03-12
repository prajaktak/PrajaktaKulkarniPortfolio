// MainView.swift
// PrajaktaKulkarniPortfolio
//
// Root navigation view. Renders a full-screen horizontally swipeable
// TabView (page style) where each page is a CardView for a portfolio section.
// Includes a dot page indicator, navigation arrows, custom animations,
// and haptic feedback on every page change.

import SwiftUI

/// The root view of the portfolio app.
/// Displays all portfolio sections as swipeable full-screen cards.
struct MainView: View {

    // MARK: - State

    @State private var viewModel = MainViewModel()

    // MARK: - Body

    var body: some View {
        ZStack {
            ThemeColor.primaryBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                cardNavigationArea
                bottomNavigationBar
            }
        }
        .preferredColorScheme(nil) // Respects system dark/light mode
    }

    // MARK: - Card Navigation Area

    private var cardNavigationArea: some View {
        TabView(selection: $viewModel.selectedSectionIndex) {
            ForEach(Array(viewModel.sections.enumerated()), id: \.offset) { sectionIndex, section in
                CardView(section: section) {
                    contentView(for: section)
                }
                .tag(sectionIndex)
                .accessibilityLabel("\(section.title) card, \(sectionIndex + 1) of \(viewModel.sections.count)")
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.selectedSectionIndex)
        .onChange(of: viewModel.selectedSectionIndex) { _, _ in
            triggerNavigationHaptic()
        }
    }

    // MARK: - Bottom Navigation Bar

    private var bottomNavigationBar: some View {
        HStack {
            previousButton
            Spacer()
            pageIndicator
            Spacer()
            nextButton
        }
        .padding(.horizontal, ThemeSpacing.large)
        .padding(.vertical, ThemeSpacing.medium)
        .background(ThemeColor.secondaryBackground)
    }

    private var previousButton: some View {
        Button {
            viewModel.navigateToPreviousSection()
        } label: {
            Image(systemName: "chevron.left")
                .font(ThemeFont.cardTitle)
                .foregroundStyle(viewModel.isFirstSection ? ThemeColor.secondaryText : ThemeColor.accentPrimary)
        }
        .disabled(viewModel.isFirstSection)
        .accessibilityLabel("Previous section")
        .accessibilityHint(viewModel.isFirstSection ? "Already on first section" : "Go to previous section")
    }

    private var nextButton: some View {
        Button {
            viewModel.navigateToNextSection()
        } label: {
            Image(systemName: "chevron.right")
                .font(ThemeFont.cardTitle)
                .foregroundStyle(viewModel.isLastSection ? ThemeColor.secondaryText : ThemeColor.accentPrimary)
        }
        .disabled(viewModel.isLastSection)
        .accessibilityLabel("Next section")
        .accessibilityHint(viewModel.isLastSection ? "Already on last section" : "Go to next section")
    }

    private var pageIndicator: some View {
        HStack(spacing: ThemeSpacing.small) {
            ForEach(Array(viewModel.sections.enumerated()), id: \.offset) { dotIndex, section in
                Circle()
                    .fill(dotIndex == viewModel.selectedSectionIndex
                          ? ThemeColor.accentPrimary
                          : ThemeColor.secondaryText.opacity(0.4))
                    .frame(width: dotIndex == viewModel.selectedSectionIndex ? 10 : 6,
                           height: dotIndex == viewModel.selectedSectionIndex ? 10 : 6)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.selectedSectionIndex)
                    .accessibilityHidden(true)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Page \(viewModel.selectedSectionIndex + 1) of \(viewModel.sections.count)")
    }

    // MARK: - Content Views

    /// Routes each CardSection identifier to its dedicated content view.
    @ViewBuilder
    private func contentView(for section: CardSection) -> some View {
        switch section.identifier {
        case "welcome":
            WelcomeView()
        case "experience":
            WorkExperienceView()
        case "skills":
            SkillsView()
        case "education":
            EducationView()
        case "competencies":
            CompetenciesView()
        case "interests":
            InterestsView()
        case "projects":
            ProjectsView()
        default:
            comingSoonPlaceholder(for: section)
        }
    }

    /// Placeholder for sections not yet implemented (Contact).
    private func comingSoonPlaceholder(for section: CardSection) -> some View {
        VStack(spacing: ThemeSpacing.medium) {
            Image(systemName: section.iconName)
                .font(.system(size: 48))
                .foregroundStyle(ThemeColor.accentPrimary)
                .accessibilityHidden(true)

            Text(section.title)
                .font(ThemeFont.heroTitle)
                .foregroundStyle(ThemeColor.primaryText)

            Text("Coming soon")
                .font(ThemeFont.bodyText)
                .foregroundStyle(ThemeColor.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(ThemeSpacing.cardPadding)
    }

    // MARK: - Haptic Feedback

    private func triggerNavigationHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

// MARK: - Preview

#Preview("Main View - Light") {
    MainView()
}

#Preview("Main View - Dark") {
    MainView()
        .preferredColorScheme(.dark)
}
