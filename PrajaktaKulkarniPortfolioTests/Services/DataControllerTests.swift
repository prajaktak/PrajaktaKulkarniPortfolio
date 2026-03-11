//
//  DataControllerTests.swift
//  PrajaktaKulkarniPortfolioTests
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//
//  Uses an in-memory SwiftData container to test DataController logic
//  without touching disk or Firebase.
//

import Testing
import Foundation
import SwiftData
@testable import PrajaktaKulkarniPortfolio

// MARK: - In-memory DataController for tests

/// A DataController variant backed by an in-memory store for isolated unit tests.
@MainActor
final class InMemoryDataController {

    let modelContainer: ModelContainer
    let modelContext: ModelContext

    init() throws {
        let schema = Schema([
            PersonalInfo.self,
            WorkExperience.self,
            Education.self,
            Skill.self,
            Language.self,
            Competency.self,
            Interest.self,
            Project.self,
            SocialLinks.self
        ])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: schema, configurations: [configuration])
        modelContext = ModelContext(modelContainer)
    }

    // MARK: - PersonalInfo

    func savePersonalInfo(_ info: PersonalInfo) throws {
        let existing = try modelContext.fetch(FetchDescriptor<PersonalInfo>())
        existing.forEach { modelContext.delete($0) }
        modelContext.insert(info)
        try modelContext.save()
    }

    func fetchPersonalInfo() throws -> PersonalInfo? {
        try modelContext.fetch(FetchDescriptor<PersonalInfo>()).first
    }

    // MARK: - WorkExperience

    func saveWorkExperiences(_ experiences: [WorkExperience]) throws {
        let existing = try modelContext.fetch(FetchDescriptor<WorkExperience>())
        existing.forEach { modelContext.delete($0) }
        experiences.forEach { modelContext.insert($0) }
        try modelContext.save()
    }

    func fetchWorkExperiences() throws -> [WorkExperience] {
        try modelContext.fetch(FetchDescriptor<WorkExperience>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        ))
    }

    // MARK: - Skills

    func saveSkills(_ skills: [Skill]) throws {
        let existing = try modelContext.fetch(FetchDescriptor<Skill>())
        existing.forEach { modelContext.delete($0) }
        skills.forEach { modelContext.insert($0) }
        try modelContext.save()
    }

    func fetchSkills() throws -> [Skill] {
        try modelContext.fetch(FetchDescriptor<Skill>())
    }

    // MARK: - Cache check

    func hasCachedData() -> Bool {
        let results = try? modelContext.fetch(FetchDescriptor<PersonalInfo>())
        return !(results?.isEmpty ?? true)
    }

    func clearAllCache() throws {
        try modelContext.delete(model: PersonalInfo.self)
        try modelContext.delete(model: WorkExperience.self)
        try modelContext.delete(model: Skill.self)
        try modelContext.save()
    }
}

// MARK: - Tests

struct DataControllerTests {

    // MARK: - PersonalInfo

    @Test("Saving personal info makes hasCachedData return true")
    @MainActor
    func savePersonalInfo_hasCachedData_returnsTrue() throws {
        let controller = try InMemoryDataController()
        let info = PersonalInfo(
            id: "pi-1",
            fullName: "Prajakta Kulkarni",
            email: "prachee.j@gmail.com",
            phoneNumber: "0612345678",
            location: "Hilversum, Netherlands",
            professionalSummary: "Senior iOS Developer"
        )
        try controller.savePersonalInfo(info)
        #expect(controller.hasCachedData() == true)
    }

    @Test("Fetching personal info returns the saved record")
    @MainActor
    func savePersonalInfo_fetchPersonalInfo_returnsSavedRecord() throws {
        let controller = try InMemoryDataController()
        let info = PersonalInfo(
            id: "pi-1",
            fullName: "Prajakta Kulkarni",
            email: "prachee.j@gmail.com",
            phoneNumber: "0612345678",
            location: "Hilversum, Netherlands",
            professionalSummary: "Senior iOS Developer"
        )
        try controller.savePersonalInfo(info)
        let fetched = try controller.fetchPersonalInfo()
        #expect(fetched?.fullName == "Prajakta Kulkarni")
    }

    @Test("Saving personal info twice keeps only the latest record")
    @MainActor
    func savePersonalInfo_savedTwice_onlyLatestRecordExists() throws {
        let controller = try InMemoryDataController()
        let firstInfo = PersonalInfo(
            id: "pi-1",
            fullName: "Old Name",
            email: "old@example.com",
            phoneNumber: "0600000000",
            location: "Amsterdam",
            professionalSummary: "Old summary"
        )
        let updatedInfo = PersonalInfo(
            id: "pi-2",
            fullName: "Prajakta Kulkarni",
            email: "prachee.j@gmail.com",
            phoneNumber: "0612345678",
            location: "Hilversum, Netherlands",
            professionalSummary: "Updated summary"
        )
        try controller.savePersonalInfo(firstInfo)
        try controller.savePersonalInfo(updatedInfo)
        let fetched = try controller.fetchPersonalInfo()
        #expect(fetched?.fullName == "Prajakta Kulkarni")
    }

    // MARK: - WorkExperience

    @Test("Saving work experiences returns correct count when fetched")
    @MainActor
    func saveWorkExperiences_fetchWorkExperiences_returnsCorrectCount() throws {
        let controller = try InMemoryDataController()
        let experiences = [
            WorkExperience(
                id: "exp-1",
                companyName: "Mirum Agency",
                jobTitle: "Lead Mobile App Developer",
                startDate: Date(timeIntervalSince1970: 1_427_846_400),
                endDate: nil,
                hoursPerWeek: 40,
                jobDescription: "Led mobile app team",
                technologiesUsed: ["Swift", "UIKit"],
                orderIndex: 1
            ),
            WorkExperience(
                id: "exp-2",
                companyName: "Tagrem India",
                jobTitle: "Lead Mobile App Developer",
                startDate: Date(timeIntervalSince1970: 1_380_585_600),
                endDate: Date(timeIntervalSince1970: 1_427_846_400),
                hoursPerWeek: 40,
                jobDescription: "iOS development",
                technologiesUsed: ["Objective-C"],
                orderIndex: 2
            )
        ]
        try controller.saveWorkExperiences(experiences)
        let fetched = try controller.fetchWorkExperiences()
        #expect(fetched.count == 2)
    }

    @Test("Saving new work experiences replaces previously saved ones")
    @MainActor
    func saveWorkExperiences_savedTwice_replacesOldData() throws {
        let controller = try InMemoryDataController()
        let firstBatch = [
            WorkExperience(
                id: "exp-old",
                companyName: "Old Company",
                jobTitle: "Developer",
                startDate: Date(timeIntervalSince1970: 1_000_000_000),
                endDate: Date(timeIntervalSince1970: 1_100_000_000),
                hoursPerWeek: 40,
                jobDescription: "Old job",
                technologiesUsed: ["ObjC"],
                orderIndex: 1
            )
        ]
        let secondBatch = [
            WorkExperience(
                id: "exp-new-1",
                companyName: "Mirum Agency",
                jobTitle: "Lead Developer",
                startDate: Date(timeIntervalSince1970: 1_427_846_400),
                endDate: nil,
                hoursPerWeek: 40,
                jobDescription: "Led mobile team",
                technologiesUsed: ["Swift"],
                orderIndex: 1
            ),
            WorkExperience(
                id: "exp-new-2",
                companyName: "Tagrem",
                jobTitle: "Developer",
                startDate: Date(timeIntervalSince1970: 1_380_585_600),
                endDate: Date(timeIntervalSince1970: 1_427_846_400),
                hoursPerWeek: 40,
                jobDescription: "iOS dev",
                technologiesUsed: ["ObjC"],
                orderIndex: 2
            )
        ]
        try controller.saveWorkExperiences(firstBatch)
        try controller.saveWorkExperiences(secondBatch)
        let fetched = try controller.fetchWorkExperiences()
        #expect(fetched.count == 2)
    }

    // MARK: - Cache Management

    @Test("Empty store has no cached data")
    @MainActor
    func emptyStore_hasCachedData_returnsFalse() throws {
        let controller = try InMemoryDataController()
        #expect(controller.hasCachedData() == false)
    }

    @Test("Clearing cache makes hasCachedData return false")
    @MainActor
    func clearAllCache_hasCachedData_returnsFalse() throws {
        let controller = try InMemoryDataController()
        let info = PersonalInfo(
            id: "pi-1",
            fullName: "Prajakta Kulkarni",
            email: "prachee.j@gmail.com",
            phoneNumber: "0612345678",
            location: "Hilversum, Netherlands",
            professionalSummary: "Senior iOS Developer"
        )
        try controller.savePersonalInfo(info)
        try controller.clearAllCache()
        #expect(controller.hasCachedData() == false)
    }

    // MARK: - Skills

    @Test("Saving skills returns correct count when fetched")
    @MainActor
    func saveSkills_fetchSkills_returnsCorrectCount() throws {
        let controller = try InMemoryDataController()
        let skills = [
            Skill(id: "sk-1", skillName: "Swift", category: "Programming Languages", proficiencyLevel: "Expert", orderIndex: 1),
            Skill(id: "sk-2", skillName: "SwiftUI", category: "iOS Frameworks", proficiencyLevel: "Advanced", orderIndex: 2),
            Skill(id: "sk-3", skillName: "Xcode", category: "Tools", proficiencyLevel: nil, orderIndex: 3)
        ]
        try controller.saveSkills(skills)
        let fetched = try controller.fetchSkills()
        #expect(fetched.count == 3)
    }
}
