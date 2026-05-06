// ResumePrintView.swift
// PrajaktaKulkarniPortfolio
//
// Standalone SwiftUI view used only for PDF rendering.
// Holds only plain value types (ResumePrintSnapshot) — no @Observable reference captured.

import SwiftUI

struct ResumePrintView: View {
    let snapshot: ResumePrintSnapshot
    let pageWidth: CGFloat
    let pageHeight: CGFloat

    private let bodySize: CGFloat    = 9.5
    private let captionSize: CGFloat = 8.5
    private let headerSize: CGFloat  = 10.5
    private let columnPadding: CGFloat  = 7
    private let leftColumnFraction: CGFloat = 0.46

    var body: some View {
        VStack(spacing: 0) {
            bannerView

            HStack(alignment: .top, spacing: 0) {
                leftCol
                    .padding(columnPadding)
                    .frame(width: pageWidth * leftColumnFraction, alignment: .topLeading)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                Rectangle().fill(Color.gray.opacity(0.25)).frame(width: 0.5)
                rightCol
                    .padding(columnPadding)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: pageWidth, height: pageHeight)
        .background(Color.white)
    }

    // MARK: Banner

    private var bannerView: some View {
        let gradient = LinearGradient(
            colors: [ThemeColor.resumePrimaryBlue, ThemeColor.resumeLightBlue],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        return VStack(spacing: 0) {
            // ── Main banner: photo + name + summary ──
            HStack(alignment: .center, spacing: 10) {
                Group {
                    if let profilePhoto = snapshot.contact.photo {
                        Image(uiImage: profilePhoto)
                            .resizable().scaledToFill()
                    } else {
                        Color.white.opacity(0.3)
                    }
                }
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.white.opacity(0.5), lineWidth: 1))

                VStack(alignment: .leading, spacing: 4) {
                    Text(snapshot.contact.fullName)
                        .font(.system(size: 17, weight: .bold)).foregroundStyle(Color.white)
                    if !snapshot.contact.summary.isEmpty {
                        Text(boldingPhrase("iOS developer", in: snapshot.contact.summary, size: 9.5))
                            .foregroundStyle(Color.white.opacity(0.9))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 8)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(gradient)

            // ── Sub-banner: phone · GitHub · LinkedIn ──
            HStack(spacing: 0) {
                if let phone = snapshot.contact.phone {
                    printContactRow(icon: "phone.fill", text: phone)
                }
                Spacer()
                if let github = snapshot.contact.github {
                    printContactRowAsset(imageName: "GitHub_Invertocat_Black", text: github)
                }
                Spacer()
                if let linkedin = snapshot.contact.linkedin {
                    printContactRowAsset(imageName: "LI-Logo", text: linkedin)
                }
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, minHeight: 20)
            .background(ThemeColor.resumeDarkBanner)
        }
        .frame(width: pageWidth)
    }

    private func printContactRow(icon: String, text: String) -> some View {
        HStack(spacing: 3) {
            Text(text).font(.system(size: 9.5)).foregroundStyle(Color.white.opacity(0.9)).lineLimit(1)
            Image(systemName: icon).font(.system(size: 8.5)).foregroundStyle(Color.white.opacity(0.75))
        }
    }

    private func printContactRowAsset(imageName: String, text: String) -> some View {
        HStack(spacing: 3) {
            Text(text).font(.system(size: 9.5)).foregroundStyle(Color.white.opacity(0.9)).lineLimit(1)
            Image(imageName).resizable().scaledToFit().frame(width: 10.5, height: 10.5)
                .colorMultiply(.white).opacity(0.85)
        }
    }

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

    // MARK: Left column — Work Experience + Certifications + Education

    private var leftCol: some View {
        VStack(alignment: .leading, spacing: 6) {
            printDivider

            // Work Experience
            printSectionHeader("WORK EXPERIENCE")
            printDivider.padding(.bottom, 4)
            ForEach(snapshot.experiences, id: \.id) { experience in
                VStack(alignment: .leading, spacing: 2) {
                    Text(experience.company)
                        .font(.system(size: bodySize, weight: .semibold)).foregroundStyle(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(experience.title)
                        .font(.system(size: bodySize, weight: .medium)).foregroundStyle(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(experience.dateRange).font(.system(size: captionSize)).foregroundStyle(ThemeColor.resumePrimaryBlue)
                    if !experience.description.isEmpty {
                        Text(experience.description)
                            .font(.system(size: captionSize))
                            .foregroundStyle(Color.black.opacity(0.7))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 1)
                    }
                }
                .padding(.bottom, 5)
            }

            printSectionSeparator

            // Education
            printSectionHeader("EDUCATION")
            printDivider.padding(.bottom, 4)
            ForEach(snapshot.education, id: \.id) { educationItem in
                VStack(alignment: .leading, spacing: 1) {
                    Text(educationItem.degree)
                        .font(.system(size: captionSize, weight: .semibold)).foregroundStyle(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(educationItem.institution)
                        .font(.system(size: captionSize - 1)).foregroundStyle(Color.black.opacity(0.7))
                    Text(educationItem.dateRange).font(.system(size: captionSize - 1)).foregroundStyle(ThemeColor.resumePrimaryBlue)
                }
                .padding(.bottom, 3)
            }

            printSectionSeparator

            // Languages
            printSectionHeader("LANGUAGES")
            printDivider.padding(.bottom, 4)
            ForEach(snapshot.languages, id: \.id) { language in
                HStack(spacing: 4) {
                    Text(language.name).font(.system(size: bodySize)).foregroundStyle(Color.black.opacity(0.85))
                    Spacer()
                    Text(language.proficiency).font(.system(size: bodySize - 1)).foregroundStyle(ThemeColor.resumePrimaryBlue)
                }
            }
        }
    }

    // MARK: Right column — Projects + Skills + Languages

    private var rightCol: some View {
        VStack(alignment: .leading, spacing: 6) {
            printDivider

            // Independent Projects
            let nonCerts = snapshot.projects.filter { !$0.isCert }.prefix(3)
            printSectionHeader("INDEPENDENT PROJECTS")
            printDivider.padding(.bottom, 4)
            ForEach(Array(nonCerts), id: \.id) { project in
                VStack(alignment: .leading, spacing: 2) {
                    Text(project.title).font(.system(size: bodySize, weight: .semibold)).foregroundStyle(Color.black)
                    if !project.description.isEmpty {
                        Text(printHighlightKeywords(in: project.description, techStack: project.techStack))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    if !project.responsibilities.isEmpty {
                        VStack(alignment: .leading, spacing: 1) {
                            ForEach(project.responsibilities, id: \.self) { responsibility in
                                HStack(alignment: .top, spacing: 3) {
                                    Circle()
                                        .fill(Color.black.opacity(0.6))
                                        .frame(width: 2.5, height: 2.5)
                                        .padding(.top, captionSize * 0.45)
                                    Text(responsibility)
                                        .font(.system(size: captionSize))
                                        .foregroundStyle(Color.black.opacity(0.7))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        .padding(.top, 2)
                    }
                }
                .padding(.bottom, 4)
            }

            printSectionSeparator

            // Skills
            printSectionHeader("SKILLS")
            printDivider.padding(.bottom, 4)
            VStack(alignment: .leading, spacing: 2) {
                ForEach(Array(printSkillPairs().enumerated()), id: \.offset) { _, pair in
                    HStack(alignment: .top, spacing: 0) {
                        printSkillBullet(pair.0).frame(maxWidth: .infinity, alignment: .leading)
                        if let secondSkill = pair.1 {
                            printSkillBullet(secondSkill).frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Spacer().frame(maxWidth: .infinity)
                        }
                    }
                }
            }

            printSectionSeparator

            // Certifications
            let certs = snapshot.projects.filter { $0.isCert }
            printSectionHeader("CERTIFICATES")
            printDivider.padding(.bottom, 4)
            ForEach(certs, id: \.id) { cert in
                VStack(alignment: .leading, spacing: 1) {
                    Text(cert.title.replacingOccurrences(of: "Certification: ", with: ""))
                        .font(.system(size: captionSize, weight: .semibold)).foregroundStyle(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                    if !cert.description.isEmpty {
                        Text(cert.description)
                            .font(.system(size: captionSize - 1)).foregroundStyle(Color.black.opacity(0.7))
                            .lineLimit(2).truncationMode(.tail)
                    }
                    Text(cert.dateRange).font(.system(size: captionSize - 1)).foregroundStyle(ThemeColor.resumePrimaryBlue)
                }
                .padding(.bottom, 3)
            }
        }
    }

    private func printSkillPairs() -> [(ResumePrintSnapshot.SkillItem, ResumePrintSnapshot.SkillItem?)] {
        // Deduplicate case-insensitively
        var seen = Set<String>()
        let unique = snapshot.skills.filter { seen.insert($0.name.lowercased()).inserted }
        var result: [(ResumePrintSnapshot.SkillItem, ResumePrintSnapshot.SkillItem?)] = []
        var skillIndex = 0
        while skillIndex < unique.count {
            result.append((unique[skillIndex], skillIndex + 1 < unique.count ? unique[skillIndex + 1] : nil))
            skillIndex += 2
        }
        return result
    }

    /// Highlights techStack keywords as bold blue in description text for print.
    private func printHighlightKeywords(in text: String, techStack: String) -> AttributedString {
        let keywords = techStack.components(separatedBy: " · ")
        var attributed = AttributedString(text)
        attributed.font = .system(size: captionSize)
        attributed.foregroundColor = UIColor.black.withAlphaComponent(0.7)
        for keyword in keywords where keyword.count > 2 {
            var searchRange = attributed.startIndex..<attributed.endIndex
            while let range = attributed[searchRange].range(of: keyword, options: .caseInsensitive) {
                attributed[range].font = .system(size: captionSize, weight: .semibold)
                attributed[range].foregroundColor = UIColor(ThemeColor.resumePrimaryBlue)
                searchRange = range.upperBound..<attributed.endIndex
            }
        }
        return attributed
    }

    private func printSkillBullet(_ skill: ResumePrintSnapshot.SkillItem) -> some View {
        HStack(alignment: .top, spacing: 3) {
            Circle().fill(ThemeColor.resumePrimaryBlue).frame(width: 4, height: 4)
                .padding(.top, bodySize * 0.3)
            Text(skill.name).font(.system(size: bodySize)).foregroundStyle(Color.black.opacity(0.85)).lineLimit(2)
        }
    }

    // MARK: Shared print helpers

    private func printSectionHeader(_ title: String) -> some View {
        Text(title).font(.system(size: headerSize, weight: .bold)).foregroundStyle(ThemeColor.resumePrimaryBlue).tracking(0.5)
    }

    /// Thin rule placed directly under a section header.
    private var printDivider: some View {
        Rectangle().fill(ThemeColor.resumePrimaryBlue.opacity(0.3)).frame(height: 0.75)
    }

    /// Thin rule used between two sections — includes vertical breathing room.
    private var printSectionSeparator: some View {
        Rectangle().fill(ThemeColor.resumePrimaryBlue.opacity(0.3)).frame(height: 0.75)
            .padding(.top, 6)
    }
}

#Preview("ResumePrintView") {
    ResumePrintView(
        snapshot: ResumePrintSnapshot(
            contact: .init(fullName: "Preview Name", summary: "iOS developer with 3 years experience.", photo: nil),
            skills: [],
            experiences: [],
            projects: [],
            languages: [],
            education: []
        ),
        pageWidth: 595,
        pageHeight: 842
    )
}
