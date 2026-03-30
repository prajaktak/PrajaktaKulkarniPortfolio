// ResumeView.swift
// PrajaktaKulkarniPortfolio
//
// Resume layout matching the reference design:
// • Full-width blue header — photo, name, title, contact links
// • Two-column body — left: own projects + certifications | right: skills + work experience + languages
// Fits in one screen (no scroll) on both iPhone and iPad.

import SwiftUI

// MARK: - ResumeView

struct ResumeView: View {

    @State private var viewModel = ResumeViewModel()

    var body: some View {
        ZStack {
            Color.white

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
                // Floating export button — not part of the printed view
                exportButton
            }
        }
        .task { await viewModel.loadAll() }
    }

    // MARK: - Floating Export Button

    private var exportButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    Task {
                        if let url = await generatePDF() {
                            presentShareSheet(url: url)
                        }
                    }
                } label: {
                    Image(systemName: "arrow.down.doc.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(.white)
                        .padding(14)
                        .background(ThemeColor.resumePrimaryBlue)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
                }
                .padding(.bottom, 28)
                .padding(.trailing, 20)
            }
        }
    }

    private func presentShareSheet(url: URL) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = scene.windows.first?.rootViewController else {
            print("❌ presentShareSheet: could not find root view controller")
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        // iPad requires a source for the popover anchor
        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = scene.windows.first
            popover.sourceRect = CGRect(
                x: UIScreen.main.bounds.maxX - 60,
                y: UIScreen.main.bounds.maxY - 100,
                width: 0, height: 0
            )
            popover.permittedArrowDirections = []
        }
        rootViewController.present(activityViewController, animated: true)
    }

    // MARK: - PDF Generation

    @MainActor
    private func generatePDF() async -> URL? {
        let pageWidth: CGFloat  = 595
        let pageHeight: CGFloat = 842

        let snapshot = makeSnapshot()
        let printView = ResumePrintView(snapshot: snapshot, pageWidth: pageWidth, pageHeight: pageHeight)

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("Prajakta_Kulkarni_Resume.pdf")

        var mediaBox = CGRect(origin: .zero, size: CGSize(width: pageWidth, height: pageHeight))

        guard let consumer = CGDataConsumer(url: url as CFURL),
              let pdfContext = CGContext(consumer: consumer, mediaBox: &mediaBox, nil)
        else { return nil }

        let renderer = ImageRenderer(content: printView)
        renderer.proposedSize = .init(width: pageWidth, height: pageHeight)
        renderer.scale = 1.0

        pdfContext.beginPDFPage(nil)
        renderer.render { _, draw in draw(pdfContext) }
        pdfContext.endPDFPage()
        pdfContext.closePDF()

        return url
    }

    /// Builds a plain-value snapshot of all viewModel data on the main actor.
    private func makeSnapshot() -> ResumePrintSnapshot {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        func formatDate(_ date: Date) -> String { dateFormatter.string(from: date) }
        func formatDateRange(start startDate: Date, end endDate: Date?) -> String {
            "\(formatDate(startDate)) – \(endDate.map { formatDate($0) } ?? "Present")"
        }

        let renderedPhoto: UIImage? = UIImage(named: "Prajakta photo")

        return ResumePrintSnapshot(
            contact: .init(
                fullName: viewModel.personalInfo?.fullName ?? "",
                summary: (viewModel.personalInfo?.professionalSummary ?? "")
                    .components(separatedBy: .newlines)
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
                    .joined(separator: " "),
                location: viewModel.personalInfo?.location,
                email: viewModel.personalInfo?.email,
                phone: viewModel.personalInfo?.phoneNumber,
                github: viewModel.socialLinks?.githubURL,
                linkedin: viewModel.socialLinks?.linkedInURL,
                photo: renderedPhoto
            ),
            skills: viewModel.skills.filter { $0.isVisible }.map { .init(id: $0.id, name: $0.skillName) },
            experiences: viewModel.experiences.map {
                .init(id: $0.id,
                      title: $0.jobTitle,
                      company: $0.companyName,
                      dateRange: formatDateRange(start: $0.startDate, end: $0.endDate))
            },
            projects: viewModel.projects.map {
                .init(id: $0.id,
                      title: $0.title,
                      techStack: $0.techStack.joined(separator: " · "),
                      description: $0.projectDescription,
                      dateRange: formatDateRange(start: $0.startDate, end: $0.endDate),
                      isCert: $0.title.lowercased().contains("certification"))
            },
            languages: viewModel.languages.map { .init(id: $0.id, name: $0.languageName, proficiency: $0.speakingProficiency) },
            education: viewModel.education.map {
                .init(id: $0.id,
                      degree: $0.degreeName,
                      institution: $0.institutionName,
                      dateRange: formatDateRange(start: $0.startDate, end: $0.endDate))
            }
        )
    }

    // MARK: - Resume Content (on-screen, safe-area aware)

    private var resumeContent: some View {
        GeometryReader { geometry in
            let isIPad             = geometry.size.width >= 700
            let isPhone            = geometry.size.width < 500
            let bodySize:    CGFloat = isPhone ? 9.5  : (isIPad ? 16.5 : 11)
            let captionSize: CGFloat = isPhone ? 8.5  : (isIPad ? 15.5 : 10)
            let headerSize:  CGFloat = isPhone ? 10.5 : (isIPad ? 17.5 : 12)
            let columnPadding:      CGFloat = isPhone ? 6   : (isIPad ? 12  : 8)
            let leftColumnFraction: CGFloat = isIPad ? 0.48 : 0.46
            VStack(spacing: 0) {
                headerBanner(geometry: geometry, isPhone: isPhone, isIPad: isIPad)
                    .padding(.bottom, 10)

                HStack(alignment: .top, spacing: 0) {
                    leftColumn(bodySize: bodySize, captionSize: captionSize, headerSize: headerSize)
                        .padding(columnPadding)
                        .frame(width: geometry.size.width * leftColumnFraction, alignment: .topLeading)
                        .frame(maxHeight: .infinity, alignment: .topLeading)

                    Rectangle().fill(Color.gray.opacity(0.25)).frame(width: 0.5)

                    rightColumn(bodySize: bodySize, captionSize: captionSize, headerSize: headerSize)
                        .padding(columnPadding)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.white)
        }
    }

    // MARK: - Header Banner (on-screen)

    private func headerBanner(geometry: GeometryProxy, isPhone: Bool, isIPad: Bool) -> some View {
        let photoSize:          CGFloat = isPhone ? 80 : 120
        let nameSize:           CGFloat = 22
        let summarySize:        CGFloat = 17
        let contactSize:        CGFloat = isPhone ? 10 : 12
        let horizontalPadding:  CGFloat = isPhone ? 12 : 18
        let topPadding:         CGFloat = geometry.safeAreaInsets.top + 8

        let gradient = LinearGradient(
            colors: [ThemeColor.resumePrimaryBlue, ThemeColor.resumeLightBlue],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )

        return VStack(spacing: 0) {
            // ── Main banner: photo + name + summary ──
            HStack(alignment: .center, spacing: isPhone ? 8 : 14) {
                Image("Prajakta photo")
                    .resizable().scaledToFill()
                    .frame(width: photoSize, height: photoSize)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.white.opacity(0.5), lineWidth: 1))

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.personalInfo?.fullName ?? "")
                        .font(.system(size: nameSize, weight: .bold))
                        .foregroundStyle(Color.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)

                    if let summary = viewModel.personalInfo?.professionalSummary {
                        let cleaned = summary
                            .components(separatedBy: .newlines)
                            .map { $0.trimmingCharacters(in: .whitespaces) }
                            .filter { !$0.isEmpty }
                            .joined(separator: " ")
                        if !cleaned.isEmpty {
                            Text(boldingPhrase("iOS developer", in: cleaned, size: summarySize))
                                .foregroundStyle(Color.white.opacity(0.9))
                        }
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.top, topPadding)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(gradient.ignoresSafeArea(edges: .top))

            // ── Sub-banner: phone · GitHub · LinkedIn ──
            HStack(spacing: 0) {
                if let phone = viewModel.personalInfo?.phoneNumber {
                    bannerContactRow(icon: "phone.fill", text: phone, size: contactSize)
                }
                Spacer()
                if let github = viewModel.socialLinks?.githubURL {
                    bannerContactRowAsset(imageName: "GitHub_Invertocat_Black", text: github, size: contactSize, tint: true)
                }
                Spacer()
                if let linkedin = viewModel.socialLinks?.linkedInURL {
                    bannerContactRowAsset(imageName: "LI-Logo", text: linkedin, size: contactSize, tint: false)
                }
            }
            .padding(.horizontal, horizontalPadding)
            .frame(maxWidth: .infinity, minHeight: 28)
            .background(ThemeColor.resumeDarkBanner)
        }
    }

    private func bannerContactRow(icon: String, text: String, size: CGFloat) -> some View {
        HStack(spacing: 3) {
            Text(text).font(.system(size: size)).foregroundStyle(Color.white.opacity(0.9))
                .lineLimit(1).minimumScaleFactor(0.75)
            Image(systemName: icon).font(.system(size: size - 1)).foregroundStyle(Color.white.opacity(0.75))
        }
    }

    private func bannerContactRowAsset(imageName: String, text: String, size: CGFloat, tint: Bool) -> some View {
        HStack(spacing: 3) {
            Text(text).font(.system(size: size)).foregroundStyle(Color.white.opacity(0.9))
                .lineLimit(1).minimumScaleFactor(0.75)
            Image(imageName).resizable().scaledToFit()
                .frame(width: size + 1, height: size + 1)
                .colorMultiply(tint ? .white : .white).opacity(0.85)
        }
    }

    /// Returns an AttributedString with `phrase` bolded wherever it appears (case-insensitive).
    private func boldingPhrase(_ phrase: String, in text: String, size: CGFloat) -> AttributedString {
        var attributed = AttributedString(text)
        attributed.font = .system(size: size, weight: .regular)
        var searchRange = attributed.startIndex..<attributed.endIndex
        while let range = attributed[searchRange].range(of: phrase, options: .caseInsensitive) {
            attributed[range].font = .system(size: size, weight: .bold)
            searchRange = range.upperBound..<attributed.endIndex
        }
        return attributed
    }

    // MARK: - Left Column (Own Projects + Certifications)

    private func leftColumn(bodySize: CGFloat, captionSize: CGFloat, headerSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            projectsSection(bodySize: bodySize, captionSize: captionSize, headerSize: headerSize)
            sectionDivider
            certificationsSection(bodySize: captionSize, headerSize: headerSize)
            sectionDivider
            educationSection(bodySize: captionSize, headerSize: headerSize)
        }
    }

    private func projectsSection(bodySize: CGFloat, captionSize: CGFloat, headerSize: CGFloat) -> some View {
        // Latest 3 non-certification projects (already ordered by startDate desc)
        let nonCerts = viewModel.projects
            .filter { !$0.title.lowercased().contains("certification") }
            .prefix(3)
        return VStack(alignment: .leading, spacing: 4) {
            sectionHeader("INDEPENDENT PROJECTS", size: headerSize)
            sectionDivider
            ForEach(Array(nonCerts), id: \.id) { project in
                VStack(alignment: .leading, spacing: 2) {
                    Text(project.title)
                        .font(.system(size: bodySize, weight: .semibold)).foregroundStyle(Color.black)
                        .padding(.bottom, 2)
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            if !project.projectDescription.isEmpty {
                                Text(highlightKeywords(in: project.projectDescription, keywords: project.techStack, size: captionSize))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(.leading, 10)
                    }
                }
                .padding(.bottom, 5)
            }
        }
    }

    /// Returns an AttributedString with techStack keywords bolded in the description.
    private func highlightKeywords(in text: String, keywords: [String], size: CGFloat) -> AttributedString {
        var attributed = AttributedString(text)
        attributed.font = .system(size: size)
        attributed.foregroundColor = UIColor.black.withAlphaComponent(0.7)
        for keyword in keywords where keyword.count > 2 {
            var searchRange = attributed.startIndex..<attributed.endIndex
            while let range = attributed[searchRange].range(of: keyword, options: .caseInsensitive) {
                attributed[range].font = .system(size: size, weight: .semibold)
                attributed[range].foregroundColor = UIColor(ThemeColor.resumePrimaryBlue)
                searchRange = range.upperBound..<attributed.endIndex
            }
        }
        return attributed
    }

    private func certificationsSection(bodySize: CGFloat, headerSize: CGFloat) -> some View {
        let certifications = viewModel.projects.filter { $0.title.lowercased().contains("certification") }
        return VStack(alignment: .leading, spacing: 4) {
            sectionHeader("CERTIFICATES", size: headerSize)
            sectionDivider
            ForEach(certifications, id: \.id) { certification in
                VStack(alignment: .leading, spacing: 1) {
                    Text(certification.title.replacingOccurrences(of: "Certification: ", with: ""))
                        .font(.system(size: bodySize, weight: .semibold)).foregroundStyle(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(2)
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            if !certification.projectDescription.isEmpty {
                                Text(certification.projectDescription)
                                    .font(.system(size: bodySize - 1)).foregroundStyle(Color.black.opacity(0.7))
                                    .lineLimit(2).truncationMode(.tail)
                            }
                            Text(viewModel.dateRange(start: certification.startDate, end: certification.endDate))
                                .font(.system(size: bodySize - 1))
                                .foregroundStyle(ThemeColor.resumePrimaryBlue)
                        }
                        .padding(.leading, 10)
                    }
                }
                .padding(.bottom, 5)
            }
        }
    }

    private func educationSection(bodySize: CGFloat, headerSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            sectionHeader("EDUCATION", size: headerSize)
            sectionDivider
            ForEach(viewModel.education, id: \.id) { educationItem in
                VStack(alignment: .leading, spacing: 1) {
                    Text(educationItem.degreeName)
                        .font(.system(size: bodySize, weight: .semibold)).foregroundStyle(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(2)
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(educationItem.institutionName)
                                .font(.system(size: bodySize - 1)).foregroundStyle(Color.black.opacity(0.7))
                                .lineLimit(2).truncationMode(.tail)
                            Text(viewModel.dateRange(start: educationItem.startDate, end: educationItem.endDate))
                                .font(.system(size: bodySize - 1))
                                .foregroundStyle(ThemeColor.resumePrimaryBlue)
                        }
                        .padding(.leading, 10)
                    }
                }
                .padding(.bottom, 5)
            }
        }
    }

    // MARK: - Right Column (Skills + Work Experience + Languages)

    private func rightColumn(bodySize: CGFloat, captionSize: CGFloat, headerSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            experienceSection(bodySize: bodySize, captionSize: captionSize, headerSize: headerSize)
            sectionDivider
            skillsSection(bodySize: bodySize, headerSize: headerSize)
            sectionDivider
            educationAndLanguages(bodySize: bodySize, captionSize: captionSize, headerSize: headerSize)
        }
    }

    private func skillsSection(bodySize: CGFloat, headerSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            sectionHeader("SKILLS", size: headerSize)
            sectionDivider
            VStack(alignment: .leading, spacing: 2) {
                ForEach(Array(skillPairs().enumerated()), id: \.offset) { _, pair in
                    HStack(alignment: .top, spacing: 0) {
                        skillBullet(pair.0, size: bodySize)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if let second = pair.1 {
                            skillBullet(second, size: bodySize)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Spacer().frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .padding(.top, 5)
        }
    }

    private func skillPairs() -> [(Skill, Skill?)] {
        // Only show visible skills, then deduplicate case-insensitively
        var seen = Set<String>()
        let unique = viewModel.skills.filter { $0.isVisible && seen.insert($0.skillName.lowercased()).inserted }
        var result: [(Skill, Skill?)] = []
        var index = 0
        while index < unique.count {
            let firstSkill = unique[index]
            let secondSkill = index + 1 < unique.count ? unique[index + 1] : nil
            result.append((firstSkill, secondSkill))
            index += 2
        }
        return result
    }

    private func skillBullet(_ skill: Skill, size: CGFloat) -> some View {
        HStack(spacing: 3) {
            Circle().fill(ThemeColor.resumePrimaryBlue).frame(width: 4, height: 4)
            Text(skill.skillName).font(.system(size: size)).foregroundStyle(Color.black.opacity(0.85)).lineLimit(1)
        }
    }

    private func experienceSection(bodySize: CGFloat, captionSize: CGFloat, headerSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            sectionHeader("WORK EXPERIENCE", size: headerSize)
            sectionDivider
            ForEach(viewModel.experiences, id: \.id) { experience in
                VStack(alignment: .leading, spacing: 2) {
                    Text(experience.companyName)
                        .font(.system(size: bodySize, weight: .semibold)).foregroundStyle(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(experience.jobTitle)
                                .font(.system(size: bodySize, weight: .medium)).foregroundStyle(Color.black)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(viewModel.dateRange(start: experience.startDate, end: experience.endDate))
                                .font(.system(size: captionSize))
                                .foregroundStyle(ThemeColor.resumePrimaryBlue)
                        }
                        .padding(.leading, 10)
                    }
                }
                .padding(.bottom, 5)
            }
        }
    }

    private func educationAndLanguages(bodySize: CGFloat, captionSize: CGFloat, headerSize: CGFloat) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                sectionHeader("LANGUAGES", size: headerSize)
                sectionDivider
                    .padding(.bottom, 5)
                ForEach(viewModel.languages, id: \.id) { language in
                    HStack(spacing: 4) {
                        Text(language.languageName).font(.system(size: bodySize)).foregroundStyle(Color.black.opacity(0.85))
                        Spacer()
                        Text(language.speakingProficiency).font(.system(size: bodySize - 1))
                            .foregroundStyle(ThemeColor.resumePrimaryBlue)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Shared Helpers

    private func sectionHeader(_ title: String, size: CGFloat) -> some View {
        Text(title).font(.system(size: size, weight: .bold))
            .foregroundStyle(ThemeColor.resumePrimaryBlue).tracking(0.5)
    }

    private var sectionDivider: some View {
        Rectangle().fill(ThemeColor.resumePrimaryBlue.opacity(0.3)).frame(height: 0.75)
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
