//
//  FirebaseServiceTests.swift
//  PrajaktaKulkarniPortfolioTests
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//
//  Unit tests for FirebaseServiceProtocol using a mock — no network required.
//

import Testing
import Foundation
@testable import PrajaktaKulkarniPortfolio

// MARK: - Mock Firebase Service

/// Mock implementation of FirebaseServiceProtocol for unit testing.
/// Returns pre-configured test data without any network calls.
@MainActor
final class MockFirebaseService: FirebaseServiceProtocol {

    var personalInfoToReturn: PersonalInfo?
    var workExperiencesToReturn: [WorkExperience] = []
    var educationToReturn: [Education] = []
    var skillsToReturn: [Skill] = []
    var languagesToReturn: [Language] = []
    var competenciesToReturn: [Competency] = []
    var interestsToReturn: [Interest] = []
    var projectsToReturn: [Project] = []
    var socialLinksToReturn: SocialLinks?
    var errorToThrow: Error?

    func fetchPersonalInfo() async throws -> PersonalInfo {
        if let error = errorToThrow { throw error }
        guard let info = personalInfoToReturn else { throw FirebaseServiceError.noDataFound }
        return info
    }

    func fetchWorkExperiences() async throws -> [WorkExperience] {
        if let error = errorToThrow { throw error }
        return workExperiencesToReturn
    }

    func fetchEducation() async throws -> [Education] {
        if let error = errorToThrow { throw error }
        return educationToReturn
    }

    func fetchSkills() async throws -> [Skill] {
        if let error = errorToThrow { throw error }
        return skillsToReturn
    }

    func fetchLanguages() async throws -> [Language] {
        if let error = errorToThrow { throw error }
        return languagesToReturn
    }

    func fetchCompetencies() async throws -> [Competency] {
        if let error = errorToThrow { throw error }
        return competenciesToReturn
    }

    func fetchInterests() async throws -> [Interest] {
        if let error = errorToThrow { throw error }
        return interestsToReturn
    }

    func fetchProjects() async throws -> [Project] {
        if let error = errorToThrow { throw error }
        return projectsToReturn
    }

    func fetchSocialLinks() async throws -> SocialLinks {
        if let error = errorToThrow { throw error }
        guard let links = socialLinksToReturn else { throw FirebaseServiceError.noDataFound }
        return links
    }
}

// MARK: - Test Data Factories

private func makePersonalInfo() -> PersonalInfo {
    PersonalInfo(
        id: "pi-1",
        fullName: "Prajakta Sarang Kulkarni",
        email: "prachee.j@gmail.com",
        phoneNumber: "0615424886",
        location: "Hilversum, Netherlands",
        professionalSummary: "Senior iOS Developer with 8+ years experience"
    )
}

private func makeWorkExperience(
    id: String,
    company: String,
    startOffset: TimeInterval,
    endOffset: TimeInterval? = nil
) -> WorkExperience {
    WorkExperience(
        id: id,
        companyName: company,
        jobTitle: "Lead Mobile App Developer",
        startDate: Date(timeIntervalSince1970: startOffset),
        endDate: endOffset.map { Date(timeIntervalSince1970: $0) },
        hoursPerWeek: 40,
        jobDescription: "Mobile app development",
        technologiesUsed: ["Swift", "UIKit"],
        orderIndex: 1
    )
}

private func makeSocialLinks() -> SocialLinks {
    SocialLinks(
        id: "sl-1",
        linkedInURL: "https://linkedin.com/in/prajakta",
        githubURL: "https://github.com/prajakta",
        emailAddress: "prachee.j@gmail.com"
    )
}

// MARK: - Personal Info Tests

@MainActor
struct FirebaseService_PersonalInfoTests {

    @Test("fetchPersonalInfo returns correct full name")
    func fetchPersonalInfo_returnsCorrectFullName() async throws {
        let mockService = MockFirebaseService()
        mockService.personalInfoToReturn = makePersonalInfo()
        let result = try await mockService.fetchPersonalInfo()
        #expect(result.fullName == "Prajakta Sarang Kulkarni")
    }

    @Test("fetchPersonalInfo returns correct email")
    func fetchPersonalInfo_returnsCorrectEmail() async throws {
        let mockService = MockFirebaseService()
        mockService.personalInfoToReturn = makePersonalInfo()
        let result = try await mockService.fetchPersonalInfo()
        #expect(result.email == "prachee.j@gmail.com")
    }

    @Test("fetchPersonalInfo returns correct location")
    func fetchPersonalInfo_returnsCorrectLocation() async throws {
        let mockService = MockFirebaseService()
        mockService.personalInfoToReturn = makePersonalInfo()
        let result = try await mockService.fetchPersonalInfo()
        #expect(result.location == "Hilversum, Netherlands")
    }

    @Test("fetchPersonalInfo throws noDataFound when no data is configured")
    func fetchPersonalInfo_noData_throwsNoDataFound() async throws {
        let mockService = MockFirebaseService()
        mockService.personalInfoToReturn = nil
        await #expect(throws: FirebaseServiceError.noDataFound) {
            _ = try await mockService.fetchPersonalInfo()
        }
    }

    @Test("fetchPersonalInfo propagates decodingError when error is configured")
    func fetchPersonalInfo_withDecodingError_throwsDecodingError() async throws {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.decodingError
        await #expect(throws: FirebaseServiceError.decodingError) {
            _ = try await mockService.fetchPersonalInfo()
        }
    }
}

// MARK: - Work Experience Tests

@MainActor
struct FirebaseService_WorkExperienceTests {

    @Test("fetchWorkExperiences returns correct count")
    func fetchWorkExperiences_returnsCorrectCount() async throws {
        let mockService = MockFirebaseService()
        mockService.workExperiencesToReturn = [
            makeWorkExperience(id: "exp-1", company: "Mirum Agency", startOffset: 1_427_846_400),
            makeWorkExperience(id: "exp-2", company: "Tagrem", startOffset: 1_380_585_600, endOffset: 1_427_846_400),
            makeWorkExperience(id: "exp-3", company: "Quadlogix", startOffset: 1_343_779_200, endOffset: 1_380_585_600),
            makeWorkExperience(id: "exp-4", company: "Arkenia", startOffset: 1_304_208_000, endOffset: 1_343_779_200),
            makeWorkExperience(id: "exp-5", company: "Ubisoft", startOffset: 1_175_385_600, endOffset: 1_304_208_000)
        ]
        let result = try await mockService.fetchWorkExperiences()
        #expect(result.count == 5)
    }

    @Test("fetchWorkExperiences returns empty array when no experiences configured")
    func fetchWorkExperiences_noData_returnsEmptyArray() async throws {
        let mockService = MockFirebaseService()
        let result = try await mockService.fetchWorkExperiences()
        #expect(result.isEmpty)
    }

    @Test("fetchWorkExperiences returns correct company name")
    func fetchWorkExperiences_returnsCorrectCompanyName() async throws {
        let mockService = MockFirebaseService()
        mockService.workExperiencesToReturn = [
            makeWorkExperience(id: "exp-1", company: "Mirum Agency", startOffset: 1_427_846_400)
        ]
        let result = try await mockService.fetchWorkExperiences()
        #expect(result.first?.companyName == "Mirum Agency")
    }

    @Test("fetchWorkExperiences returns experience with no end date as current position")
    func fetchWorkExperiences_noEndDate_isCurrentPosition() async throws {
        let mockService = MockFirebaseService()
        mockService.workExperiencesToReturn = [
            makeWorkExperience(id: "exp-1", company: "Mirum Agency", startOffset: 1_427_846_400, endOffset: nil)
        ]
        let result = try await mockService.fetchWorkExperiences()
        #expect(result.first?.isCurrentPosition == true)
    }
}

// MARK: - Skills Tests

@MainActor
struct FirebaseService_SkillsTests {

    @Test("fetchSkills returns correct count")
    func fetchSkills_returnsCorrectCount() async throws {
        let mockService = MockFirebaseService()
        mockService.skillsToReturn = [
            Skill(id: "sk-1", skillName: "Swift", category: "Programming Languages", proficiencyLevel: "Expert", orderIndex: 1),
            Skill(id: "sk-2", skillName: "SwiftUI", category: "iOS Frameworks", proficiencyLevel: "Advanced", orderIndex: 2),
            Skill(id: "sk-3", skillName: "Xcode", category: "Tools", proficiencyLevel: nil, orderIndex: 3)
        ]
        let result = try await mockService.fetchSkills()
        #expect(result.count == 3)
    }

    @Test("fetchSkills returns Programming Languages category")
    func fetchSkills_containsProgrammingLanguagesCategory() async throws {
        let mockService = MockFirebaseService()
        mockService.skillsToReturn = [
            Skill(id: "sk-1", skillName: "Swift", category: "Programming Languages", proficiencyLevel: nil, orderIndex: 1)
        ]
        let result = try await mockService.fetchSkills()
        let categories = result.map { $0.category }
        #expect(categories.contains("Programming Languages"))
    }

    @Test("fetchSkills returns iOS Frameworks category")
    func fetchSkills_containsiOSFrameworksCategory() async throws {
        let mockService = MockFirebaseService()
        mockService.skillsToReturn = [
            Skill(id: "sk-2", skillName: "SwiftUI", category: "iOS Frameworks", proficiencyLevel: nil, orderIndex: 2)
        ]
        let result = try await mockService.fetchSkills()
        let categories = result.map { $0.category }
        #expect(categories.contains("iOS Frameworks"))
    }
}

// MARK: - Languages Tests

@MainActor
struct FirebaseService_LanguagesTests {

    @Test("fetchLanguages returns correct count")
    func fetchLanguages_returnsCorrectCount() async throws {
        let mockService = MockFirebaseService()
        mockService.languagesToReturn = [
            Language(id: "lang-1", languageName: "Dutch", speakingProficiency: "Reasonable", writingProficiency: "Reasonable"),
            Language(id: "lang-2", languageName: "English", speakingProficiency: "Good", writingProficiency: "Good"),
            Language(id: "lang-3", languageName: "Hindi", speakingProficiency: "Good", writingProficiency: "Good")
        ]
        let result = try await mockService.fetchLanguages()
        #expect(result.count == 3)
    }

    @Test("fetchLanguages returns Dutch language")
    func fetchLanguages_containsDutch() async throws {
        let mockService = MockFirebaseService()
        mockService.languagesToReturn = [
            Language(id: "lang-1", languageName: "Dutch", speakingProficiency: "Reasonable", writingProficiency: "Reasonable")
        ]
        let result = try await mockService.fetchLanguages()
        #expect(result.map { $0.languageName }.contains("Dutch"))
    }

    @Test("fetchLanguages returns English language")
    func fetchLanguages_containsEnglish() async throws {
        let mockService = MockFirebaseService()
        mockService.languagesToReturn = [
            Language(id: "lang-2", languageName: "English", speakingProficiency: "Good", writingProficiency: "Good")
        ]
        let result = try await mockService.fetchLanguages()
        #expect(result.map { $0.languageName }.contains("English"))
    }
}

// MARK: - Competencies Tests

@MainActor
struct FirebaseService_CompetenciesTests {

    @Test("fetchCompetencies returns correct count")
    func fetchCompetencies_returnsCorrectCount() async throws {
        let mockService = MockFirebaseService()
        mockService.competenciesToReturn = [
            Competency(id: "comp-1", competencyTitle: "Teamwork", competencyDescription: "Collaboration and teamwork", orderIndex: 1),
            Competency(id: "comp-2", competencyTitle: "Mentoring", competencyDescription: "Guiding others", orderIndex: 2)
        ]
        let result = try await mockService.fetchCompetencies()
        #expect(result.count == 2)
    }

    @Test("fetchCompetencies returns competencies with non-empty titles")
    func fetchCompetencies_titlesAreNotEmpty() async throws {
        let mockService = MockFirebaseService()
        mockService.competenciesToReturn = [
            Competency(id: "comp-1", competencyTitle: "Teamwork", competencyDescription: "Collaboration", orderIndex: 1)
        ]
        let result = try await mockService.fetchCompetencies()
        #expect(!(result.first?.competencyTitle.isEmpty ?? true))
    }
}

// MARK: - Interests Tests

@MainActor
struct FirebaseService_InterestsTests {

    @Test("fetchInterests returns correct count")
    func fetchInterests_returnsCorrectCount() async throws {
        let mockService = MockFirebaseService()
        mockService.interestsToReturn = [
            Interest(id: "int-1", interestTitle: "Cycling", interestDescription: "Road cycling", orderIndex: 1),
            Interest(id: "int-2", interestTitle: "Reading", interestDescription: "Novels in multiple languages", orderIndex: 2)
        ]
        let result = try await mockService.fetchInterests()
        #expect(result.count == 2)
    }

    @Test("fetchInterests returns interests with non-empty titles")
    func fetchInterests_titlesAreNotEmpty() async throws {
        let mockService = MockFirebaseService()
        mockService.interestsToReturn = [
            Interest(id: "int-1", interestTitle: "Cycling", interestDescription: "Road cycling", orderIndex: 1)
        ]
        let result = try await mockService.fetchInterests()
        #expect(!(result.first?.interestTitle.isEmpty ?? true))
    }
}

// MARK: - Projects Tests

@MainActor
struct FirebaseService_ProjectsTests {

    @Test("fetchProjects returns featured project as first result")
    func fetchProjects_firstProjectIsFeatured() async throws {
        let mockService = MockFirebaseService()
        mockService.projectsToReturn = [
            Project(
                id: "proj-1",
                title: "Sequence Game",
                startDate: Date(timeIntervalSince1970: 1_753_920_000),
                endDate: nil,
                projectDescription: "A memory card game built with SwiftUI",
                techStack: ["SwiftUI", "TDD", "CI/CD"],
                githubURL: "https://github.com/prajakta/sequence",
                screenshotURLs: [],
                demoVideoURL: nil,
                isFeatured: true,
                orderIndex: 1
            )
        ]
        let result = try await mockService.fetchProjects()
        #expect(result.first?.isFeatured == true)
    }

    @Test("fetchProjects returns correct project title")
    func fetchProjects_returnsCorrectTitle() async throws {
        let mockService = MockFirebaseService()
        mockService.projectsToReturn = [
            Project(
                id: "proj-1",
                title: "Sequence Game",
                startDate: Date(timeIntervalSince1970: 1_753_920_000),
                endDate: nil,
                projectDescription: "A memory card game",
                techStack: ["SwiftUI"],
                githubURL: nil,
                screenshotURLs: [],
                demoVideoURL: nil,
                isFeatured: true,
                orderIndex: 1
            )
        ]
        let result = try await mockService.fetchProjects()
        #expect(result.first?.title == "Sequence Game")
    }

    @Test("fetchProjects returns ongoing project when endDate is nil")
    func fetchProjects_nilEndDate_isOngoing() async throws {
        let mockService = MockFirebaseService()
        mockService.projectsToReturn = [
            Project(
                id: "proj-1",
                title: "Sequence Game",
                startDate: Date(timeIntervalSince1970: 1_753_920_000),
                endDate: nil,
                projectDescription: "A memory card game",
                techStack: ["SwiftUI"],
                githubURL: nil,
                screenshotURLs: [],
                demoVideoURL: nil,
                isFeatured: true,
                orderIndex: 1
            )
        ]
        let result = try await mockService.fetchProjects()
        #expect(result.first?.isOngoing == true)
    }
}

// MARK: - Social Links Tests

@MainActor
struct FirebaseService_SocialLinksTests {

    @Test("fetchSocialLinks returns LinkedIn URL containing linkedin.com")
    func fetchSocialLinks_linkedInURLContainsLinkedIn() async throws {
        let mockService = MockFirebaseService()
        mockService.socialLinksToReturn = makeSocialLinks()
        let result = try await mockService.fetchSocialLinks()
        #expect(result.linkedInURL.contains("linkedin.com"))
    }

    @Test("fetchSocialLinks returns GitHub URL containing github.com")
    func fetchSocialLinks_githubURLContainsGitHub() async throws {
        let mockService = MockFirebaseService()
        mockService.socialLinksToReturn = makeSocialLinks()
        let result = try await mockService.fetchSocialLinks()
        #expect(result.githubURL.contains("github.com"))
    }

    @Test("fetchSocialLinks returns email containing @ symbol")
    func fetchSocialLinks_emailContainsAtSymbol() async throws {
        let mockService = MockFirebaseService()
        mockService.socialLinksToReturn = makeSocialLinks()
        let result = try await mockService.fetchSocialLinks()
        #expect(result.emailAddress.contains("@"))
    }

    @Test("fetchSocialLinks throws noDataFound when no links configured")
    func fetchSocialLinks_noData_throwsNoDataFound() async throws {
        let mockService = MockFirebaseService()
        mockService.socialLinksToReturn = nil
        await #expect(throws: FirebaseServiceError.noDataFound) {
            _ = try await mockService.fetchSocialLinks()
        }
    }
}

// MARK: - FirebaseServiceError Tests

@MainActor
struct FirebaseServiceErrorTests {

    @Test("noDataFound error has non-empty description")
    func noDataFound_errorDescription_isNotEmpty() {
        let error = FirebaseServiceError.noDataFound
        #expect(!(error.errorDescription?.isEmpty ?? true))
    }

    @Test("decodingError has non-empty description")
    func decodingError_errorDescription_isNotEmpty() {
        let error = FirebaseServiceError.decodingError
        #expect(!(error.errorDescription?.isEmpty ?? true))
    }
}
