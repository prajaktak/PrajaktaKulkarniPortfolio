// MainView.swift
// PrajaktaKulkarniPortfolio
//
// Root navigation view.
// Layout: left sidebar tabs + right vertical ScrollView with all sections stacked.
// Tapping a sidebar tab scrolls to that section.

import SwiftUI

struct MainView: View {

    // MARK: - State

    @State private var viewModel = MainViewModel()
    @State private var selectedIndex: Int = 0
    @State private var scrollTrigger: UUID = UUID()

    // MARK: - Body

    var body: some View {
        ZStack {
            ThemeColor.primaryBackground.ignoresSafeArea()

            HStack(spacing: 0) {
                sidebar
                Divider()
                scrollContent
            }
        }
        .preferredColorScheme(nil)
    }

    // MARK: - Left Sidebar

    private var sidebar: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 0) {
                ForEach(Array(viewModel.sections.enumerated()), id: \.offset) { index, section in
                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            selectedIndex = index
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: section.iconName)
                                .font(.system(size: 18, weight: selectedIndex == index ? .bold : .regular))
                                .foregroundStyle(selectedIndex == index ? ThemeColor.accentPrimary : ThemeColor.tertiaryText)
                                .frame(width: 28, height: 28)

                            Text(section.title)
                                .font(.system(size: 9, weight: selectedIndex == index ? .semibold : .regular))
                                .foregroundStyle(selectedIndex == index ? ThemeColor.accentPrimary : ThemeColor.tertiaryText)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .frame(width: 56)
                        }
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedIndex == index
                                ? ThemeColor.accentPrimary.opacity(0.1)
                                : Color.clear
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 4)
                }
            }
            .padding(.top, ThemeSpacing.medium)
        }
        .frame(width: 68)
        .background(ThemeColor.cardBackground)
    }

    // MARK: - Scrollable Content

    private var scrollContent: some View {
        GeometryReader { geo in
            let cardHeight = geo.size.height - ThemeSpacing.medium * 2

            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: ThemeSpacing.medium) {
                        ForEach(Array(viewModel.sections.enumerated()), id: \.offset) { index, section in
                            CardView(section: section) {
                                contentView(for: section)
                            }
                            .frame(height: cardHeight)
                            .id(index)
                        }
                    }
                    .padding(.vertical, ThemeSpacing.medium)
                }
                .onChange(of: selectedIndex) { _, newIndex in
                    withAnimation(.easeInOut(duration: 0.4)) {
                        proxy.scrollTo(newIndex, anchor: .top)
                    }
                }
                .onChange(of: scrollTrigger) { _, _ in
                    withAnimation(.easeInOut(duration: 0.4)) {
                        proxy.scrollTo(selectedIndex, anchor: .top)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ThemeColor.primaryBackground)
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
        case "contact":      ContactView(onBackToTop: {
            selectedIndex = 0
            scrollTrigger = UUID()
        })
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

#Preview("iPad") {
    MainView()
        .environment(\.horizontalSizeClass, .regular)
}

#Preview("iPhone") {
    MainView()
}
