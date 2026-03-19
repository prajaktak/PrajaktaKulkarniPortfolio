// ResumeView.swift
// PrajaktaKulkarniPortfolio
//
// A resume-style screen matching the PDF layout:
// left column — photo, name, contact, summary, skills, languages, certifications
// right column — own projects, work experience

import SwiftUI

struct ResumeView: View {

    @State private var viewModel = ResumeViewModel()

    var body: some View {
        ZStack {
            ThemeColor.primaryBackground.ignoresSafeArea()

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
            let isIPad        = geo.size.width >= 700
            let isPhone       = geo.size.width < 500
            let leftWidth     = geo.size.width * (isIPad ? 0.30 : 0.32)
            let bodySize:    CGFloat = isPhone ? 9  : (isIPad ? 12 : 11)
            let captionSize: CGFloat = isPhone ? 8  : (isIPad ? 11 : 10)
            let headerSize:  CGFloat = isPhone ? 10 : (isIPad ? 13 : 12)
            let padding:     CGFloat = isIPad ? ThemeSpacing.large : (isPhone ? ThemeSpacing.small : ThemeSpacing.medium)

            HStack(alignment: .top, spacing: 0) {
                leftColumn(bodySize: bodySize, captionSize: captionSize, headerSize: headerSize)
                    .padding(padding)
                    .frame(width: leftWidth)
                    .frame(maxHeight: .infinity, alignment: .topLeading)

                Divider()
                    .background(ThemeColor.divider)

                rightColumn(bodySize: bodySize, captionSize: captionSize, headerSize: headerSize, showDescriptions: isIPad)
                    .padding(padding)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.white)
        }
    }

    // MARK: - Left Column

    private func leftColumn(bodySize: CGFloat, captionSize: CGFloat, headerSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
            photoAndName(captionSize: captionSize)
            contactInfo(captionSize: captionSize)
            sectionDivider
            summarySection(bodySize: captionSize)
            sectionDivider
            skillsSection(bodySize: captionSize, headerSize: headerSize)
            sectionDivider
            languagesSection(bodySize: captionSize, headerSize: headerSize)
            sectionDivider
            certificationsSection(bodySize: captionSize, headerSize: headerSize)
        }
        .padding(.trailing, ThemeSpacing.small)
    }

    private func photoAndName(captionSize: CGFloat) -> some View {
        HStack(alignment: .center, spacing: ThemeSpacing.small) {
            Image("Prajakta photo")
                .resizable()
                .scaledToFill()
                .frame(width: 52, height: 52)
                .clipShape(RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.personalInfo?.fullName ?? "")
                    .font(.system(size: captionSize + 2, weight: .bold))
                    .foregroundStyle(Color.black)
                Text(viewModel.personalInfo?.location ?? "")
                    .font(.system(size: captionSize))
                    .foregroundStyle(Color.gray)
            }
        }
    }

    private func contactInfo(captionSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            if let email = viewModel.personalInfo?.email {
                contactRow(icon: "envelope.fill", text: email, size: captionSize)
            }
            if let phone = viewModel.personalInfo?.phoneNumber {
                contactRow(icon: "phone.fill", text: phone, size: captionSize)
            }
            if let github = viewModel.socialLinks?.githubURL {
                contactRowCustom(imageName: "GitHub_Invertocat_Black", text: github, size: captionSize)
            }
            if let linkedin = viewModel.socialLinks?.linkedInURL {
                contactRowCustom(imageName: "LI-Logo", text: linkedin, size: captionSize)
            }
        }
    }

    private func contactRow(icon: String, text: String, size: CGFloat) -> some View {
        HStack(spacing: 3) {
            Image(systemName: icon)
                .font(.system(size: size - 1))
                .foregroundStyle(ThemeColor.accentPrimary)
                .frame(width: 12)
            Text(text)
                .font(.system(size: size))
                .foregroundStyle(Color.black)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }

    private func contactRowCustom(imageName: String, text: String, size: CGFloat) -> some View {
        HStack(spacing: 3) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
            Text(text)
                .font(.system(size: size))
                .foregroundStyle(Color.black)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }

    private func summarySection(bodySize: CGFloat) -> some View {
        Group {
            if let summary = viewModel.personalInfo?.professionalSummary {
                Text(summary)
                    .font(.system(size: bodySize))
                    .foregroundStyle(Color.black.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func skillsSection(bodySize: CGFloat, headerSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            sectionHeader("Skills", size: headerSize)
            ForEach(viewModel.skills, id: \.id) { skill in
                HStack(spacing: 4) {
                    Text(skill.skillName)
                        .font(.system(size: bodySize))
                        .foregroundStyle(Color.black.opacity(0.85))
                        .lineLimit(1)
                    Spacer()
                    if let level = skill.proficiencyLevel {
                        Text(level)
                            .font(.system(size: bodySize - 1))
                            .foregroundStyle(ThemeColor.accentPrimary)
                    }
                }
            }
        }
    }

    private func languagesSection(bodySize: CGFloat, headerSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            sectionHeader("Languages", size: headerSize)
            ForEach(viewModel.languages, id: \.id) { lang in
                HStack(spacing: 4) {
                    Text(lang.languageName)
                        .font(.system(size: bodySize))
                        .foregroundStyle(Color.black.opacity(0.85))
                        .lineLimit(1)
                    Spacer()
                    Text(lang.speakingProficiency)
                        .font(.system(size: bodySize - 1))
                        .foregroundStyle(ThemeColor.accentPrimary)
                }
            }
        }
    }

    private func certificationsSection(bodySize: CGFloat, headerSize: CGFloat) -> some View {
        let certs = viewModel.projects.filter { $0.title.lowercased().contains("certification") }
        return VStack(alignment: .leading, spacing: 5) {
            sectionHeader("Certifications", size: headerSize)
            ForEach(certs, id: \.id) { cert in
                VStack(alignment: .leading, spacing: 2) {
                    Text(cert.title.replacingOccurrences(of: "Certification: ", with: ""))
                        .font(.system(size: bodySize, weight: .semibold))
                        .foregroundStyle(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                    if !cert.projectDescription.isEmpty {
                        Text(cert.projectDescription)
                            .font(.system(size: bodySize - 1))
                            .foregroundStyle(Color.black.opacity(0.75))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Text(viewModel.dateRange(start: cert.startDate, end: cert.endDate))
                        .font(.system(size: bodySize - 1))
                        .foregroundStyle(ThemeColor.accentPrimary)
                }
            }
        }
    }

    // MARK: - Right Column

    private func rightColumn(bodySize: CGFloat, captionSize: CGFloat, headerSize: CGFloat, showDescriptions: Bool) -> some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.small) {
            projectsSection(bodySize: bodySize, captionSize: captionSize, headerSize: headerSize, showDescriptions: showDescriptions)
            Spacer()
            sectionDivider
            experienceSection(bodySize: bodySize, captionSize: captionSize, headerSize: headerSize, showDescriptions: showDescriptions)
        }
        .padding(.leading, ThemeSpacing.small)
    }

    private func projectsSection(bodySize: CGFloat, captionSize: CGFloat, headerSize: CGFloat, showDescriptions: Bool) -> some View {
        let nonCerts = viewModel.projects.filter { !$0.title.lowercased().contains("certification") }
        return VStack(alignment: .leading, spacing: showDescriptions ? 8 : 4) {
            sectionHeader("Own Projects:", size: headerSize)
            ForEach(Array(nonCerts.enumerated()), id: \.element.id) { index, project in
                HStack(alignment: .top, spacing: 3) {
                    Text("\(index + 1).")
                        .font(.system(size: bodySize))
                        .foregroundStyle(Color.black)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(project.title)
                            .font(.system(size: bodySize, weight: .semibold))
                            .foregroundStyle(Color.black)
                        Text(project.techStack.joined(separator: ", "))
                            .font(.system(size: captionSize))
                            .foregroundStyle(Color.black.opacity(0.65))
                        if showDescriptions {
                            Text(project.projectDescription)
                                .font(.system(size: captionSize))
                                .foregroundStyle(Color.black.opacity(0.75))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 1)
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.bottom, 6)
            }
        }
    }

    private func experienceSection(bodySize: CGFloat, captionSize: CGFloat, headerSize: CGFloat, showDescriptions: Bool) -> some View {
        VStack(alignment: .leading, spacing: showDescriptions ? 8 : 4) {
            sectionHeader("Experience:", size: headerSize)
            ForEach(Array(viewModel.experiences.enumerated()), id: \.element.id) { index, exp in
                HStack(alignment: .top, spacing: 3) {
                    Text("\(index + 1).")
                        .font(.system(size: bodySize))
                        .foregroundStyle(Color.black)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(exp.jobTitle) — \(exp.companyName)")
                            .font(.system(size: bodySize, weight: .semibold))
                            .foregroundStyle(Color.black)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(viewModel.dateRange(start: exp.startDate, end: exp.endDate))
                            .font(.system(size: captionSize))
                            .foregroundStyle(Color.gray)
                        if showDescriptions && !exp.jobDescription.isEmpty {
                            Text(exp.jobDescription)
                                .font(.system(size: captionSize))
                                .foregroundStyle(Color.black.opacity(0.75))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 1)
                        }
                    }
                }
                .padding(.bottom, 6)
            }
        }
    }

    // MARK: - Shared Helpers

    private func sectionHeader(_ title: String, size: CGFloat = 12) -> some View {
        Text(title)
            .font(.system(size: size, weight: .bold))
            .foregroundStyle(Color.black)
    }

    private var sectionDivider: some View {
        Divider()
            .background(Color.gray.opacity(0.4))
    }
}

// MARK: - Preview

#Preview("Resume") {
    ResumeView()
}
