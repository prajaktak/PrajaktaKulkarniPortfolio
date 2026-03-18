// MainView.swift
// PrajaktaKulkarniPortfolio
//
// Root navigation view.
// iPhone: tab bar with one tab per section.
// iPad: split layout — narrow left panel (About, Skills + More) and
//       wide right panel (Experience, Projects). Sizes scale with
//       actual screen geometry so 11" and 13" both look correct.

import SwiftUI

/// The root view of the portfolio app.
/// Adapts automatically between iPhone tab bar and iPad split-panel layouts.
struct MainView: View {

    // MARK: - State

    @State private var viewModel = MainViewModel()
    @State private var showMoreSheet = false
    @State private var moreSheetSection: CardSection? = nil
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    // MARK: - Body

    var body: some View {
        if horizontalSizeClass == .regular {
            iPadLayout
        } else {
            iPhoneLayout
        }
    }

    // MARK: - iPhone Layout (Tab Bar)

    private var iPhoneLayout: some View {
        ZStack {
            ThemeColor.primaryBackground.ignoresSafeArea()

            TabView(selection: $viewModel.selectedSectionIndex) {
                ForEach(Array(viewModel.sections.enumerated()), id: \.offset) { sectionIndex, section in
                    CardView(section: section) {
                        contentView(for: section)
                    }
                    .tag(sectionIndex)
                    .tabItem {
                        Label(section.title, systemImage: section.iconName)
                    }
                }
            }
            .tint(ThemeColor.accentPrimary)
        }
        .preferredColorScheme(nil)
    }

    // MARK: - iPad Layout (Split Panel)

    private var iPadLayout: some View {
        ZStack {
            ThemeColor.primaryBackground.ignoresSafeArea()

            HStack(alignment: .top, spacing: ThemeSpacing.medium) {

                // ── Left panel: scrollable, content-sized ─────────────────
                    VStack(spacing: ThemeSpacing.medium) {
                        iPadCard(identifier: "welcome")
                        iPadCard(identifier: "skills")
                        morePanel
                    }
                    .padding(.vertical, ThemeSpacing.medium)
                .frame(width: 300)

                // ── Right panel: two cards each taking half the height ─────
                VStack(spacing: ThemeSpacing.medium) {
                    iPadCard(identifier: "experience")
                        .frame(maxHeight: .infinity)
                    iPadCard(identifier: "projects")
                        .frame(maxHeight: .infinity)
                }
                .padding(.vertical, ThemeSpacing.medium)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, ThemeSpacing.medium)
        }
        .preferredColorScheme(nil)
        .sheet(isPresented: $showMoreSheet) {
            if let section = moreSheetSection {
                moreSheetContent(for: section)
            }
        }
    }

    // MARK: - iPad Card Helper

    private func iPadCard(identifier: String) -> some View {
        let section = viewModel.sections.first { $0.identifier == identifier }
                   ?? CardSection.allPortfolioSections[0]
        return CardView(section: section) {
            contentView(for: section)
        }
    }

    // MARK: - More Panel

    private var moreSections: [CardSection] {
        viewModel.sections.filter {
            ["education", "competencies", "interests", "contact"].contains($0.identifier)
        }
    }

    private var morePanel: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
            Text("More")
                .font(ThemeFont.subheading)
                .foregroundStyle(ThemeColor.primaryText)
                .padding(.top, ThemeSpacing.extraSmall)

            ForEach(moreSections) { section in
                Button {
                    moreSheetSection = section
                    showMoreSheet = true
                } label: {
                    HStack(spacing: ThemeSpacing.small) {
                        Image(systemName: section.iconName)
                            .font(.system(size: 16))
                            .foregroundStyle(ThemeColor.accentPrimary)
                            .frame(width: 24)
                        Text(section.title)
                            .font(ThemeFont.bodyText)
                            .foregroundStyle(ThemeColor.primaryText)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundStyle(ThemeColor.tertiaryText)
                    }
                    .padding(.horizontal, ThemeSpacing.medium)
                    .padding(.vertical, ThemeSpacing.small)
                    .background(ThemeColor.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(ThemeSpacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ThemeColor.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: ThemeSpacing.cardCornerRadius))
        .shadow(
            color: ThemeColor.cardShadow,
            radius: ThemeSpacing.cardShadowRadius,
            x: 0,
            y: ThemeSpacing.cardShadowYOffset
        )
        .padding(.horizontal, ThemeSpacing.horizontalPageInset)
    }

    // MARK: - More Sheet

    private func moreSheetContent(for section: CardSection) -> some View {
        NavigationStack {
            ZStack {
                ThemeColor.primaryBackground.ignoresSafeArea()
                CardView(section: section) {
                    contentView(for: section)
                }
                .padding(.vertical, ThemeSpacing.medium)
            }
            .navigationTitle(section.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { showMoreSheet = false }
                        .foregroundStyle(ThemeColor.accentPrimary)
                }
            }
        }
    }

    // MARK: - Shared Content Router

    @ViewBuilder
    private func contentView(for section: CardSection) -> some View {
        switch section.identifier {
        case "welcome":      WelcomeView()
        case "experience":   WorkExperienceView()
        case "skills":       SkillsView()
        case "education":    EducationView()
        case "competencies": CompetenciesView()
        case "interests":    InterestsView()
        case "projects":     ProjectsView()
        case "contact":      ContactView()
        default:
            VStack(spacing: ThemeSpacing.medium) {
                Image(systemName: section.iconName)
                    .font(.system(size: 48))
                    .foregroundStyle(ThemeColor.accentPrimary)
                    .accessibilityHidden(true)
                Text("Coming soon")
                    .font(ThemeFont.bodyText)
                    .foregroundStyle(ThemeColor.secondaryText)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(ThemeSpacing.cardPadding)
        }
    }
}

// MARK: - Preview

#Preview("iPad Portrait") {
    MainView()
        .environment(\.horizontalSizeClass, .regular)
}

#Preview("iPhone") {
    MainView()
}

