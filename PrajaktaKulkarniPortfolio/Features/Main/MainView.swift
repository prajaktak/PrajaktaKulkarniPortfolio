// MainView.swift
// PrajaktaKulkarniPortfolio
//
// Root navigation view.
// iPhone: left sidebar + vertical ScrollView, sidebar highlights on scroll.
// iPad: split layout — narrow left panel (About, Skills + More) and
//       wide right panel (Experience, Projects).

import SwiftUI

// MARK: - Preference Key for card visibility tracking (iPhone)

private struct CardOffsetKey: PreferenceKey {
    static let defaultValue: [Int: CGFloat] = [:]
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue()) { $1 }
    }
}

struct MainView: View {

    // MARK: - State

    @State private var viewModel = MainViewModel()
    @State private var selectedIndex: Int = 0
    @State private var scrollTrigger: UUID = UUID()
    @State private var isProgrammaticScroll = false
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

    // MARK: - iPhone Layout (Sidebar + Vertical Scroll)

    private var iPhoneLayout: some View {
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

    // MARK: - Left Sidebar (iPhone)

    private var sidebar: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 0) {
                ForEach(Array(viewModel.sections.enumerated()), id: \.offset) { index, section in
                    Button {
                        isProgrammaticScroll = true
                        selectedIndex = index
                        scrollTrigger = UUID()
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

    // MARK: - Scrollable Content (iPhone)

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
                            .background(
                                GeometryReader { cardGeo in
                                    Color.clear.preference(
                                        key: CardOffsetKey.self,
                                        value: [index: cardGeo.frame(in: .named("scrollArea")).minY]
                                    )
                                }
                            )
                        }
                    }
                    .padding(.vertical, ThemeSpacing.medium)
                }
                .coordinateSpace(name: "scrollArea")
                .onPreferenceChange(CardOffsetKey.self) { offsets in
                    guard !isProgrammaticScroll else { return }
                    let visible = offsets.min { abs($0.value) < abs($1.value) }
                    if let visible, visible.key != selectedIndex {
                        selectedIndex = visible.key
                    }
                }
                .onChange(of: scrollTrigger) { _, _ in
                    withAnimation(.easeInOut(duration: 0.4)) {
                        proxy.scrollTo(selectedIndex, anchor: .top)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isProgrammaticScroll = false
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ThemeColor.primaryBackground)
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

    // MARK: - More Panel (iPad)

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

    // MARK: - More Sheet (iPad)

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
        case "contact":      ContactView(onBackToTop: {
            isProgrammaticScroll = true
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
