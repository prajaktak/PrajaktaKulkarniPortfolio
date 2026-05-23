// ContactView.swift
// PrajaktaKulkarniPortfolio
//
// Displays the Contact card with tappable LinkedIn, GitHub,
// and email links loaded from Firebase SocialLinks.

import SwiftUI

/// Displays the Contact card with social links and email.
struct ContactView: View {

    // MARK: - Properties

    var onBackToTop: (() -> Void)? = nil

    // MARK: - State

    @State private var viewModel = ContactViewModel()

    // MARK: - Body

    var body: some View {
        ScrollView {
            Group {
                switch viewModel.viewState {
                case .idle, .loading:
                    loadingContent
                case .loaded:
                    loadedContent
                case .error(let message):
                    errorContent(message: message)
                }
            }
        }
        .task {
            await viewModel.loadContact()
        }
    }

    // MARK: - Loading State

    private var loadingContent: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
            ForEach(0..<3, id: \.self) { _ in
                skeletonRow
            }
        }
        .padding(ThemeSpacing.cardPadding)
        .accessibilityLabel("Loading contact information")
    }

    private var skeletonRow: some View {
        HStack(spacing: ThemeSpacing.medium) {
            RoundedRectangle(cornerRadius: 10)
                .fill(ThemeColor.secondaryBackground)
                .frame(width: 44, height: 44)
                .opacity(0.6)
            RoundedRectangle(cornerRadius: 6)
                .fill(ThemeColor.secondaryBackground)
                .frame(width: 160, height: 16)
                .opacity(0.5)
        }
    }

    // MARK: - Loaded State

    private var loadedContent: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.medium) {
            if let links = viewModel.socialLinks {
                // LinkedIn
                if let url = URL(string: links.linkedInURL) {
                    contactAssetLinkRow(
                        assetName: "LI-Logo",
                        label: "LinkedIn",
                        subtitle: links.linkedInURL
                            .replacingOccurrences(of: "https://", with: "")
                            .replacingOccurrences(of: "http://", with: ""),
                        url: url,
                        color: ThemeColor.accentPrimary
                    )
                }

                Divider().background(ThemeColor.divider)

                // GitHub
                if let url = URL(string: links.githubURL) {
                    contactAssetLinkRow(
                        assetName: "GitHub_Invertocat_Black",
                        label: "GitHub",
                        subtitle: links.githubURL
                            .replacingOccurrences(of: "https://", with: "")
                            .replacingOccurrences(of: "http://", with: ""),
                        url: url,
                        color: ThemeColor.primaryText
                    )
                }

                Divider().background(ThemeColor.divider)

                // Email
                if let url = URL(string: "mailto:\(links.emailAddress)") {
                    contactLinkRow(
                        iconName: "envelope.fill",
                        label: "Email",
                        subtitle: links.emailAddress,
                        url: url,
                        color: ThemeColor.accentSecondary
                    )
                }
            }

            if let onBackToTop {
                Spacer()
                Divider().background(ThemeColor.divider)
                Button {
                    onBackToTop()
                } label: {
                    HStack(spacing: ThemeSpacing.small) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 18))
                        Text("Back to Top")
                            .font(ThemeFont.subheading)
                    }
                    .foregroundStyle(ThemeColor.accentPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(ThemeSpacing.medium)
                    .background(ThemeColor.accentPrimary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(ThemeSpacing.cardPadding)
    }

    private func contactLinkRow(
        iconName: String,
        label: String,
        subtitle: String,
        url: URL,
        color: Color
    ) -> some View {
        Link(destination: url) {
            HStack(spacing: ThemeSpacing.medium) {
                // Icon circle
                ZStack {
                    Circle()
                        .fill(color.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: iconName)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(color)
                        .accessibilityHidden(true)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(ThemeFont.subheading)
                        .foregroundStyle(ThemeColor.primaryText)
                    Text(subtitle)
                        .font(ThemeFont.captionText)
                        .foregroundStyle(ThemeColor.secondaryText)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(ThemeFont.captionText)
                    .foregroundStyle(ThemeColor.tertiaryText)
                    .accessibilityHidden(true)
            }
        }
        .accessibilityLabel("Open \(label)")
        .accessibilityHint("Opens \(label) in browser or mail app")
    }

    private func contactAssetLinkRow(
        assetName: String,
        label: String,
        subtitle: String,
        url: URL,
        color: Color
    ) -> some View {
        Link(destination: url) {
            HStack(spacing: ThemeSpacing.medium) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(assetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .accessibilityHidden(true)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(ThemeFont.subheading)
                        .foregroundStyle(ThemeColor.primaryText)
                    Text(subtitle)
                        .font(ThemeFont.captionText)
                        .foregroundStyle(ThemeColor.secondaryText)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(ThemeFont.captionText)
                    .foregroundStyle(ThemeColor.tertiaryText)
                    .accessibilityHidden(true)
            }
        }
        .accessibilityLabel("Open \(label)")
        .accessibilityHint("Opens \(label) in browser or mail app")
    }

    // MARK: - Error State

    private func errorContent(message: String) -> some View {
        VStack(spacing: ThemeSpacing.medium) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 36))
                .foregroundStyle(ThemeColor.accentSecondary)
                .accessibilityHidden(true)

            Text("Could not load contact info")
                .font(ThemeFont.cardTitle)
                .foregroundStyle(ThemeColor.primaryText)

            Text(message)
                .font(ThemeFont.captionText)
                .foregroundStyle(ThemeColor.secondaryText)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task { await viewModel.loadContact() }
            }
            .font(ThemeFont.bodySmall)
            .foregroundStyle(ThemeColor.accentPrimary)
        }
        .padding(ThemeSpacing.cardPadding)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview

#Preview("Contact Card") {
    ContactView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ThemeColor.primaryBackground)
}

#Preview("Contact Card - Dark") {
    ContactView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ThemeColor.primaryBackground)
        .preferredColorScheme(.dark)
}
