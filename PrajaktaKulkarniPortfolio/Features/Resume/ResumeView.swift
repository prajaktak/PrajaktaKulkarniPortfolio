// ResumeView.swift
// PrajaktaKulkarniPortfolio
//
// Resume layout matching the reference design:
// • Full-width blue header — photo, name, title, contact links
// • Two-column body — left: experience + certifications | right: skills + education + languages
// Fits in one screen (no scroll) on both iPhone and iPad.

import SwiftUI

struct ResumeView: View {

    @State private var viewModel = ResumeViewModel()

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            switch viewModel.viewState {
            case .idle, .loading:
                ProgressView("Loading resume…")
                    .foregroundStyle(ThemeColor.secondaryText)
            case .error(let msg):
                VStack(spacing: ThemeSpacing.medium) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(ThemeColor.accentSecondary)
                    Text("Could not load resume")
                        .font(ThemeFont.cardTitle)
                    Text(msg)
                        .font(ThemeFont.captionText)
                        .foregroundStyle(ThemeColor.secondaryText)
                        .multilineTextAlignment(.center)
                    Button("Try Again") { Task { await viewModel.loadAll() } }
                        .foregroundStyle(ThemeColor.accentPrimary)
                }
                .padding()
            case .loaded:
                resumeContent
            }
        }
        .task { await viewModel.loadAll() }
    }

    // MARK: - Resume Content

    private var resumeContent: some View {
        GeometryReader { geo in
            let isIPad    = geo.size.width >= 700
            let isPhone   = geo.size.width < 500
            // Scale font sizes to available space
            let bodySize:    CGFloat = isPhone ? 8.5 : (isIPad ? 11.5 : 10)
            let captionSize: CGFloat = isPhone ? 7.5 : (isIPad ? 10.5 : 9)
            let headerSize:  CGFloat = isPhone ? 9.5 : (isIPad ? 12.5 : 11)
            let colPad:      CGFloat = isPhone ? 6   : (isIPad ? 12  : 8)
            let leftFrac:    CGFloat = isIPad ? 0.48 : 0.46

            VStack(spacing: 0) {
                // ── Full-width header ────────────────────────────────────────
                headerBanner(geo: geo, isPhone: isPhone, isIPad: isIPad)

                // ── Two-column body ──────────────────────────────────────────
                HStack(alignment: .top, spacing: 0) {
                    // Left column
                    leftColumn(
                        bodySize: bodySize,
                        captionSize: captionSize,
                        headerSize: headerSize
                    )
                    .padding(colPad)
                    .frame(width: geo.size.width * leftFrac, alignment: .topLeading)
                    .frame(maxHeight: .infinity, alignment: .topLeading)

                    // Thin divider
                    Rectangle()
                        .fill(Color.gray.opacity(0.25))
                        .frame(width: 0.5)

                    // Right column
                    rightColumn(
                        bodySize: bodySize,
                        captionSize: captionSize,
                        headerSize: headerSize
                    )
                    .padding(colPad)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.white)
        }
    }

    // MARK: - Header Banner

    private func headerBanner(geo: GeometryProxy, isPhone: Bool, isIPad: Bool) -> some View {
        let bannerH: CGFloat = isPhone ? 72 : (isIPad ? 110 : 88)
        let photoSize: CGFloat = isPhone ? 48 : (isIPad ? 72 : 58)
        let nameSize: CGFloat  = isPhone ? 13 : (isIPad ? 20 : 16)
        let titleSize: CGFloat = isPhone ? 9  : (isIPad ? 13 : 11)
        let infoSize: CGFloat  = isPhone ? 7.5: (isIPad ? 10 : 8.5)
        let hPad: CGFloat      = isPhone ? 10 : (isIPad ? 20 : 14)

        return ZStack(alignment: .leading) {
            // Blue gradient background
            LinearGradient(
                colors: [Color(red: 0.12, green: 0.28, blue: 0.55), Color(red: 0.20, green: 0.45, blue: 0.75)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            HStack(alignment: .center, spacing: isPhone ? 8 : 14) {
                // Photo
                Image("Prajakta photo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: photoSize, height: photoSize)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )

                // Name + title
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.personalInfo?.fullName ?? "")
                        .font(.system(size: nameSize, weight: .bold))
                        .foregroundStyle(Color.white)

                    if let summary = viewModel.personalInfo?.professionalSummary,
                       let firstLine = summary.components(separatedBy: ".").first {
                        Text(firstLine.trimmingCharacters(in: .whitespaces))
                            .font(.system(size: titleSize, weight: .medium))
                            .foregroundStyle(Color.white.opacity(0.85))
                            .lineLimit(2)
                            .minimumScaleFactor(0.75)
                    }

                    if let loc = viewModel.personalInfo?.location {
                        HStack(spacing: 3) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: infoSize))
                            Text(loc)
                                .font(.system(size: infoSize))
                        }
                        .foregroundStyle(Color.white.opacity(0.75))
                    }
                }

                Spacer()

                // Contact info (right side of header)
                VStack(alignment: .trailing, spacing: 3) {
                    if let email = viewModel.personalInfo?.email {
                        bannerContactRow(icon: "envelope.fill", text: email, size: infoSize)
                    }
                    if let phone = viewModel.personalInfo?.phoneNumber {
                        bannerContactRow(icon: "phone.fill", text: phone, size: infoSize)
                    }
                    if let github = viewModel.socialLinks?.githubURL {
                        bannerContactRowAsset(imageName: "GitHub_Invertocat_Black", text: github, size: infoSize, tint: true)
                    }
                    if let linkedin = viewModel.socialLinks?.linkedInURL {
                        bannerContactRowAsset(imageName: "LI-Logo", text: linkedin, size: infoSize, tint: false)
                    }
                }
            }
            .padding(.horizontal, hPad)
            .padding(.vertical, 8)
        }
        .frame(height: bannerH)
    }

    private func bannerContactRow(icon: String, text: String, size: CGFloat) -> some View {
        HStack(spacing: 3) {
            Text(text)
                .font(.system(size: size))
                .foregroundStyle(Color.white.opacity(0.9))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Image(systemName: icon)
                .font(.system(size: size - 1))
                .foregroundStyle(Color.white.opacity(0.75))
        }
    }

    private func bannerContactRowAsset(imageName: String, text: String, size: CGFloat, tint: Bool) -> some View {
        HStack(spacing: 3) {
            Text(text)
                .font(.system(size: size))
                .foregroundStyle(Color.white.opacity(0.9))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: size + 1, height: size + 1)
                .colorMultiply(tint ? .white : .white)
                .opacity(0.85)
        }
    }

    // MARK: - Left Column (Experience + Certifications)

    private func leftColumn(bodySize: CGFloat, captionSize: CGFloat, headerSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            experienceSection(bodySize: bodySize, captionSize: captionSize, headerSize: headerSize)
            sectionDivider
            certificationsSection(bodySize: captionSize, headerSize: headerSize)
        }
    }

    private func experienceSection(bodySize: CGFloat, captionSize: CGFloat, headerSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            sectionHeader("WORK EXPERIENCE", size: headerSize)
            sectionDivider
            ForEach(viewModel.experiences, id: \.id) { exp in
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(exp.jobTitle) — \(exp.companyName)")
                        .font(.system(size: bodySize, weight: .semibold))
                        .foregroundStyle(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(viewModel.dateRange(start: exp.startDate, end: exp.endDate))
                        .font(.system(size: captionSize))
                        .foregroundStyle(Color(red: 0.12, green: 0.28, blue: 0.55))
                    if !exp.jobDescription.isEmpty {
                        Text(exp.jobDescription)
                            .font(.system(size: captionSize))
                            .foregroundStyle(Color.black.opacity(0.7))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.bottom, 5)
            }
        }
    }

    private func certificationsSection(bodySize: CGFloat, headerSize: CGFloat) -> some View {
        let certs = viewModel.projects.filter { $0.title.lowercased().contains("certification") }
        return VStack(alignment: .leading, spacing: 4) {
            sectionHeader("CERTIFICATES", size: headerSize)
            sectionDivider
            ForEach(certs, id: \.id) { cert in
                VStack(alignment: .leading, spacing: 1) {
                    Text(cert.title.replacingOccurrences(of: "Certification: ", with: ""))
                        .font(.system(size: bodySize, weight: .semibold))
                        .foregroundStyle(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                    if !cert.projectDescription.isEmpty {
                        Text(cert.projectDescription)
                            .font(.system(size: bodySize - 1))
                            .foregroundStyle(Color.black.opacity(0.7))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Text(viewModel.dateRange(start: cert.startDate, end: cert.endDate))
                        .font(.system(size: bodySize - 1))
                        .foregroundStyle(Color(red: 0.12, green: 0.28, blue: 0.55))
                }
                .padding(.bottom, 3)
            }
        }
    }

    // MARK: - Right Column (Skills + Projects + Education + Languages)

    private func rightColumn(bodySize: CGFloat, captionSize: CGFloat, headerSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            skillsSection(bodySize: bodySize, headerSize: headerSize)
            sectionDivider
            projectsSection(bodySize: bodySize, captionSize: captionSize, headerSize: headerSize)
            sectionDivider
            educationAndLanguages(bodySize: bodySize, captionSize: captionSize, headerSize: headerSize)
        }
    }

    private func skillsSection(bodySize: CGFloat, headerSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            sectionHeader("SKILLS", size: headerSize)
            sectionDivider
            // Two-column skills grid
            let cols = Array(repeating: GridItem(.flexible(), alignment: .leading), count: 2)
            LazyVGrid(columns: cols, alignment: .leading, spacing: 2) {
                ForEach(viewModel.skills, id: \.id) { skill in
                    HStack(spacing: 3) {
                        Circle()
                            .fill(Color(red: 0.12, green: 0.28, blue: 0.55))
                            .frame(width: 4, height: 4)
                        Text(skill.skillName)
                            .font(.system(size: bodySize))
                            .foregroundStyle(Color.black.opacity(0.85))
                            .lineLimit(1)
                    }
                }
            }
        }
    }

    private func projectsSection(bodySize: CGFloat, captionSize: CGFloat, headerSize: CGFloat) -> some View {
        let nonCerts = viewModel.projects.filter { !$0.title.lowercased().contains("certification") }
        return VStack(alignment: .leading, spacing: 4) {
            sectionHeader("OWN PROJECTS", size: headerSize)
            sectionDivider
            ForEach(nonCerts, id: \.id) { project in
                VStack(alignment: .leading, spacing: 2) {
                    Text(project.title)
                        .font(.system(size: bodySize, weight: .semibold))
                        .foregroundStyle(Color.black)
                    Text(project.techStack.joined(separator: " · "))
                        .font(.system(size: captionSize))
                        .foregroundStyle(Color.black.opacity(0.6))
                        .lineLimit(1)
                    if !project.projectDescription.isEmpty {
                        Text(project.projectDescription)
                            .font(.system(size: captionSize))
                            .foregroundStyle(Color.black.opacity(0.7))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.bottom, 4)
            }
        }
    }

    private func educationAndLanguages(bodySize: CGFloat, captionSize: CGFloat, headerSize: CGFloat) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // Languages
            VStack(alignment: .leading, spacing: 4) {
                sectionHeader("LANGUAGES", size: headerSize)
                sectionDivider
                ForEach(viewModel.languages, id: \.id) { lang in
                    HStack(spacing: 4) {
                        Text(lang.languageName)
                            .font(.system(size: bodySize))
                            .foregroundStyle(Color.black.opacity(0.85))
                        Spacer()
                        Text(lang.speakingProficiency)
                            .font(.system(size: bodySize - 1))
                            .foregroundStyle(Color(red: 0.12, green: 0.28, blue: 0.55))
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Shared Helpers

    private func sectionHeader(_ title: String, size: CGFloat) -> some View {
        Text(title)
            .font(.system(size: size, weight: .bold))
            .foregroundStyle(Color(red: 0.12, green: 0.28, blue: 0.55))
            .tracking(0.5)
    }

    private var sectionDivider: some View {
        Rectangle()
            .fill(Color(red: 0.12, green: 0.28, blue: 0.55).opacity(0.3))
            .frame(height: 0.75)
    }
}

// MARK: - Preview

#Preview("Resume – iPhone") {
    ResumeView()
}

#Preview("Resume – iPad") {
    ResumeView()
        .frame(width: 768, height: 1024)
}
