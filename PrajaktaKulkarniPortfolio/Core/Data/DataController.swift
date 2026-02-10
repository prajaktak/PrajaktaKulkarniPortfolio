//
//  DataController.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 10/02/2026.
//

import Foundation
import SwiftData

@MainActor
final class DataController {

    static let shared = DataController()

    let modelContainer: ModelContainer
    let modelContext: ModelContext

    private init() {
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

        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: false)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = ModelContext(modelContainer)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    // MARK: - Personal Info

    func savePersonalInfo(_ info: PersonalInfo) throws {
        // Delete existing personal info (should only be one)
        let fetchDescriptor = FetchDescriptor<PersonalInfo>()
        let existing = try modelContext.fetch(fetchDescriptor)
        existing.forEach { modelContext.delete($0) }

        // Insert new data
        modelContext.insert(info)
        try modelContext.save()
    }

    func fetchPersonalInfo() throws -> PersonalInfo? {
        let fetchDescriptor = FetchDescriptor<PersonalInfo>()
        let results = try modelContext.fetch(fetchDescriptor)
        return results.first
    }

    // MARK: - Work Experience

    func saveWorkExperiences(_ experiences: [WorkExperience]) throws {
        // Delete existing work experiences
        let fetchDescriptor = FetchDescriptor<WorkExperience>()
        let existing = try modelContext.fetch(fetchDescriptor)
        existing.forEach { modelContext.delete($0) }

        // Insert new data
        experiences.forEach { modelContext.insert($0) }
        try modelContext.save()
    }

    func fetchWorkExperiences() throws -> [WorkExperience] {
        let fetchDescriptor = FetchDescriptor<WorkExperience>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        return try modelContext.fetch(fetchDescriptor)
    }

    // MARK: - Education

    func saveEducation(_ education: [Education]) throws {
        // Delete existing education entries
        let fetchDescriptor = FetchDescriptor<Education>()
        let existing = try modelContext.fetch(fetchDescriptor)
        existing.forEach { modelContext.delete($0) }

        // Insert new data
        education.forEach { modelContext.insert($0) }
        try modelContext.save()
    }

    func fetchEducation() throws -> [Education] {
        let fetchDescriptor = FetchDescriptor<Education>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        return try modelContext.fetch(fetchDescriptor)
    }

    // MARK: - Skills

    func saveSkills(_ skills: [Skill]) throws {
        // Delete existing skills
        let fetchDescriptor = FetchDescriptor<Skill>()
        let existing = try modelContext.fetch(fetchDescriptor)
        existing.forEach { modelContext.delete($0) }

        // Insert new data
        skills.forEach { modelContext.insert($0) }
        try modelContext.save()
    }

    func fetchSkills() throws -> [Skill] {
        let fetchDescriptor = FetchDescriptor<Skill>(
            sortBy: [SortDescriptor(\.category)]
        )
        return try modelContext.fetch(fetchDescriptor)
    }

    // MARK: - Languages

    func saveLanguages(_ languages: [Language]) throws {
        // Delete existing languages
        let fetchDescriptor = FetchDescriptor<Language>()
        let existing = try modelContext.fetch(fetchDescriptor)
        existing.forEach { modelContext.delete($0) }

        // Insert new data
        languages.forEach { modelContext.insert($0) }
        try modelContext.save()
    }

    func fetchLanguages() throws -> [Language] {
        let fetchDescriptor = FetchDescriptor<Language>()
        return try modelContext.fetch(fetchDescriptor)
    }

    // MARK: - Competencies

    func saveCompetencies(_ competencies: [Competency]) throws {
        // Delete existing competencies
        let fetchDescriptor = FetchDescriptor<Competency>()
        let existing = try modelContext.fetch(fetchDescriptor)
        existing.forEach { modelContext.delete($0) }

        // Insert new data
        competencies.forEach { modelContext.insert($0) }
        try modelContext.save()
    }

    func fetchCompetencies() throws -> [Competency] {
        let fetchDescriptor = FetchDescriptor<Competency>()
        return try modelContext.fetch(fetchDescriptor)
    }

    // MARK: - Interests

    func saveInterests(_ interests: [Interest]) throws {
        // Delete existing interests
        let fetchDescriptor = FetchDescriptor<Interest>()
        let existing = try modelContext.fetch(fetchDescriptor)
        existing.forEach { modelContext.delete($0) }

        // Insert new data
        interests.forEach { modelContext.insert($0) }
        try modelContext.save()
    }

    func fetchInterests() throws -> [Interest] {
        let fetchDescriptor = FetchDescriptor<Interest>()
        return try modelContext.fetch(fetchDescriptor)
    }

    // MARK: - Projects

    func saveProjects(_ projects: [Project]) throws {
        // Delete existing projects
        let fetchDescriptor = FetchDescriptor<Project>()
        let existing = try modelContext.fetch(fetchDescriptor)
        existing.forEach { modelContext.delete($0) }

        // Insert new data
        projects.forEach { modelContext.insert($0) }
        try modelContext.save()
    }

    func fetchProjects() throws -> [Project] {
        let fetchDescriptor = FetchDescriptor<Project>(
            sortBy: [SortDescriptor(\.orderIndex)]
        )
        let projects = try modelContext.fetch(fetchDescriptor)
        // Sort featured projects first
        return projects.sorted { $0.isFeatured && !$1.isFeatured }
    }

    // MARK: - Social Links

    func saveSocialLinks(_ links: SocialLinks) throws {
        // Delete existing social links (should only be one)
        let fetchDescriptor = FetchDescriptor<SocialLinks>()
        let existing = try modelContext.fetch(fetchDescriptor)
        existing.forEach { modelContext.delete($0) }

        // Insert new data
        modelContext.insert(links)
        try modelContext.save()
    }

    func fetchSocialLinks() throws -> SocialLinks? {
        let fetchDescriptor = FetchDescriptor<SocialLinks>()
        let results = try modelContext.fetch(fetchDescriptor)
        return results.first
    }

    // MARK: - Cache Management

    func clearAllCache() throws {
        // Delete all cached data
        try modelContext.delete(model: PersonalInfo.self)
        try modelContext.delete(model: WorkExperience.self)
        try modelContext.delete(model: Education.self)
        try modelContext.delete(model: Skill.self)
        try modelContext.delete(model: Language.self)
        try modelContext.delete(model: Competency.self)
        try modelContext.delete(model: Interest.self)
        try modelContext.delete(model: Project.self)
        try modelContext.delete(model: SocialLinks.self)

        try modelContext.save()
    }

    func hasCachedData() -> Bool {
        do {
            let personalInfoDescriptor = FetchDescriptor<PersonalInfo>()
            let personalInfoResults = try modelContext.fetch(personalInfoDescriptor)
            return !personalInfoResults.isEmpty
        } catch {
            return false
        }
    }
}
