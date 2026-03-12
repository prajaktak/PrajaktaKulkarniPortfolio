// WelcomeView.swift
// PrajaktaKulkarniPortfolio
//
// The first card in the portfolio — shows name, title, location, and professional summary.
// Renders loading skeleton, error state, or full content depending on WelcomeViewModel.viewState.

import SwiftUI

/// Displays the Welcome/About card with personal information.
struct WelcomeView: View {

    // MARK: - State

    @State private var viewModel = WelcomeViewModel()

    // MARK: - Body

    var body: some View {
        Group {
            switch viewModel.viewState {
            case .idle, .loading:
                loadingContent
            case .loaded:
                if let info = viewModel.personalInfo {
                    loadedContent(info: info)
                }
            case .error(let message):
                errorContent(message: message)
            }
        }
        .task {
            await viewModel.loadPersonalInfo()
        }
    }

    // MARK: - Loading State

    private var loadingContent: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
            skeletonRow(width: 200, height: 28)
            skeletonRow(width: 140, height: 18)
            skeletonRow(width: 160, height: 16)
            Divider()
            skeletonRow(width: .infinity, height: 14)
            skeletonRow(width: .infinity, height: 14)
            skeletonRow(width: 260, height: 14)
        }
        .padding(ThemeSpacing.cardPadding)
        .accessibilityLabel("Loading personal information")
    }

    private func skeletonRow(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(ThemeColor.secondaryBackground)
            .frame(maxWidth: width == .infinity ? .infinity : width, minHeight: height, maxHeight: height)
            .opacity(0.6)
    }

    // MARK: - Loaded State

    private func loadedContent(info: PersonalInfo) -> some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.large) {
            heroSection(info: info)
            contactSection(info: info, links: viewModel.socialLinks)
            Divider().background(ThemeColor.divider)
            summarySection(info: info)
        }
        .padding(ThemeSpacing.cardPadding)
    }

    private func heroSection(info: PersonalInfo) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: ThemeSpacing.extraSmall) {
                Image("Prajakta photo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(ThemeColor.accentPrimary, lineWidth: 2))
                    .accessibilityLabel("Profile photo of \(info.fullName)")
                Spacer()
            }
            VStack(alignment: .leading, spacing: ThemeSpacing.extraSmall) {

                Text(info.fullName)
                    .font(ThemeFont.sectionTitle)
                    .foregroundStyle(ThemeColor.primaryText)
                    .accessibilityAddTraits(.isHeader)

                Text(info.location)
                    .font(ThemeFont.subheading)
                    .foregroundStyle(ThemeColor.accentPrimary)
            }
        }
        
    }

    private func summarySection(info: PersonalInfo) -> some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
            Text("About Me")
                .font(ThemeFont.cardTitle)
                .foregroundStyle(ThemeColor.primaryText)

            Text(info.professionalSummary)
                .font(ThemeFont.bodyText)
                .foregroundStyle(ThemeColor.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func contactSection(info: PersonalInfo, links: SocialLinks?) -> some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
            contactRow(iconName: "envelope.fill", value: info.email)
            contactRow(iconName: "phone.fill", value: info.phoneNumber)
            if let githubURL = links.flatMap({ URL(string: $0.githubURL) }) {
                linkRow(badge: gitHubBadge, label: "github.com/prajaktak", url: githubURL)
            }
            if let linkedInURL = links.flatMap({ URL(string: $0.linkedInURL) }) {
                linkRow(badge: linkedInBadge, label: "linkedin.com/in/kulkarnips", url: linkedInURL)
            }
        }
    }

    private func contactRow(iconName: String, value: String) -> some View {
        HStack(spacing: ThemeSpacing.small) {
            Image(systemName: iconName)
                .font(ThemeFont.captionText)
                .foregroundStyle(ThemeColor.accentPrimary)
                .frame(width: 16)
                .accessibilityHidden(true)

            Text(value)
                .font(ThemeFont.bodySmall)
                .foregroundStyle(ThemeColor.secondaryText)
        }
    }

    private func linkRow(badge: some View, label: String, url: URL) -> some View {
        Link(destination: url) {
            HStack(spacing: ThemeSpacing.small) {
                badge
                    .frame(width: 16, height: 16)
                    .accessibilityHidden(true)

                Text(label)
                    .font(ThemeFont.bodySmall)
                    .foregroundStyle(ThemeColor.accentPrimary)
            }
        }
    }

    private var linkedInBadge: some View {
        Image("LI-Logo")
            .resizable()
            .scaledToFit()
    }

    private var gitHubBadge: some View {
        Image("GitHub_Invertocat_Black")
            .resizable()
            .scaledToFit()
    }

    // MARK: - Error State

    private func errorContent(message: String) -> some View {
        VStack(spacing: ThemeSpacing.medium) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 36))
                .foregroundStyle(ThemeColor.accentSecondary)
                .accessibilityHidden(true)

            Text("Could not load profile")
                .font(ThemeFont.cardTitle)
                .foregroundStyle(ThemeColor.primaryText)

            Text(message)
                .font(ThemeFont.captionText)
                .foregroundStyle(ThemeColor.secondaryText)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task { await viewModel.loadPersonalInfo() }
            }
            .font(ThemeFont.bodySmall)
            .foregroundStyle(ThemeColor.accentPrimary)
        }
        .padding(ThemeSpacing.cardPadding)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview

#Preview("Welcome Card") {
    CardView(section: CardSection.allPortfolioSections[0]) {
        WelcomeView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
}

#Preview("Welcome Card - Dark") {
    CardView(section: CardSection.allPortfolioSections[0]) {
        WelcomeView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeColor.primaryBackground)
    .preferredColorScheme(.dark)
}
