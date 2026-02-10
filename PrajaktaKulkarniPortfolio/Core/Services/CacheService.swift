//
//  CacheService.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 10/02/2026.
//

import Foundation

@MainActor
final class CacheService {

    static let shared = CacheService()

    private let firebaseService = FirebaseService()
    private let dataController = DataController.shared

    private init() {}

    // MARK: - Sync All Data

    func syncAllData() async throws {
        async let personalInfo = firebaseService.fetchPersonalInfo()
        async let workExperiences = firebaseService.fetchWorkExperiences()
        async let education = firebaseService.fetchEducation()
        async let skills = firebaseService.fetchSkills()
        async let languages = firebaseService.fetchLanguages()
        async let competencies = firebaseService.fetchCompetencies()
        async let interests = firebaseService.fetchInterests()
        async let projects = firebaseService.fetchProjects()
        async let socialLinks = firebaseService.fetchSocialLinks()

        let (pInfo, wExps, edu, skl, lang, comp, intr, proj, sLinks) = try await (
            personalInfo, workExperiences, education, skills,
            languages, competencies, interests, projects, socialLinks
        )

        // Save all to local cache
        try dataController.savePersonalInfo(pInfo)
        try dataController.saveWorkExperiences(wExps)
        try dataController.saveEducation(edu)
        try dataController.saveSkills(skl)
        try dataController.saveLanguages(lang)
        try dataController.saveCompetencies(comp)
        try dataController.saveInterests(intr)
        try dataController.saveProjects(proj)
        try dataController.saveSocialLinks(sLinks)
    }

    // MARK: - Personal Info

    func getPersonalInfo(forceRefresh: Bool = false) async throws -> PersonalInfo {
        if forceRefresh || !dataController.hasCachedData() {
            let info = try await firebaseService.fetchPersonalInfo()
            try dataController.savePersonalInfo(info)
            return info
        }

        if let cachedInfo = try dataController.fetchPersonalInfo() {
            return cachedInfo
        }

        // Fallback to Firebase if cache is empty
        let info = try await firebaseService.fetchPersonalInfo()
        try dataController.savePersonalInfo(info)
        return info
    }

    // MARK: - Work Experience

    func getWorkExperiences(forceRefresh: Bool = false) async throws -> [WorkExperience] {
        if forceRefresh || !dataController.hasCachedData() {
            let experiences = try await firebaseService.fetchWorkExperiences()
            try dataController.saveWorkExperiences(experiences)
            return experiences
        }

        let cachedExperiences = try dataController.fetchWorkExperiences()
        if !cachedExperiences.isEmpty {
            return cachedExperiences
        }

        // Fallback to Firebase if cache is empty
        let experiences = try await firebaseService.fetchWorkExperiences()
        try dataController.saveWorkExperiences(experiences)
        return experiences
    }

    // MARK: - Education

    func getEducation(forceRefresh: Bool = false) async throws -> [Education] {
        if forceRefresh || !dataController.hasCachedData() {
            let education = try await firebaseService.fetchEducation()
            try dataController.saveEducation(education)
            return education
        }

        let cachedEducation = try dataController.fetchEducation()
        if !cachedEducation.isEmpty {
            return cachedEducation
        }

        // Fallback to Firebase
        let education = try await firebaseService.fetchEducation()
        try dataController.saveEducation(education)
        return education
    }

    // MARK: - Skills

    func getSkills(forceRefresh: Bool = false) async throws -> [Skill] {
        if forceRefresh || !dataController.hasCachedData() {
            let skills = try await firebaseService.fetchSkills()
            try dataController.saveSkills(skills)
            return skills
        }

        let cachedSkills = try dataController.fetchSkills()
        if !cachedSkills.isEmpty {
            return cachedSkills
        }

        // Fallback to Firebase
        let skills = try await firebaseService.fetchSkills()
        try dataController.saveSkills(skills)
        return skills
    }

    // MARK: - Languages

    func getLanguages(forceRefresh: Bool = false) async throws -> [Language] {
        if forceRefresh || !dataController.hasCachedData() {
            let languages = try await firebaseService.fetchLanguages()
            try dataController.saveLanguages(languages)
            return languages
        }

        let cachedLanguages = try dataController.fetchLanguages()
        if !cachedLanguages.isEmpty {
            return cachedLanguages
        }

        // Fallback to Firebase
        let languages = try await firebaseService.fetchLanguages()
        try dataController.saveLanguages(languages)
        return languages
    }

    // MARK: - Competencies

    func getCompetencies(forceRefresh: Bool = false) async throws -> [Competency] {
        if forceRefresh || !dataController.hasCachedData() {
            let competencies = try await firebaseService.fetchCompetencies()
            try dataController.saveCompetencies(competencies)
            return competencies
        }

        let cachedCompetencies = try dataController.fetchCompetencies()
        if !cachedCompetencies.isEmpty {
            return cachedCompetencies
        }

        // Fallback to Firebase
        let competencies = try await firebaseService.fetchCompetencies()
        try dataController.saveCompetencies(competencies)
        return competencies
    }

    // MARK: - Interests

    func getInterests(forceRefresh: Bool = false) async throws -> [Interest] {
        if forceRefresh || !dataController.hasCachedData() {
            let interests = try await firebaseService.fetchInterests()
            try dataController.saveInterests(interests)
            return interests
        }

        let cachedInterests = try dataController.fetchInterests()
        if !cachedInterests.isEmpty {
            return cachedInterests
        }

        // Fallback to Firebase
        let interests = try await firebaseService.fetchInterests()
        try dataController.saveInterests(interests)
        return interests
    }

    // MARK: - Projects

    func getProjects(forceRefresh: Bool = false) async throws -> [Project] {
        if forceRefresh || !dataController.hasCachedData() {
            let projects = try await firebaseService.fetchProjects()
            try dataController.saveProjects(projects)
            return projects
        }

        let cachedProjects = try dataController.fetchProjects()
        if !cachedProjects.isEmpty {
            return cachedProjects
        }

        // Fallback to Firebase
        let projects = try await firebaseService.fetchProjects()
        try dataController.saveProjects(projects)
        return projects
    }

    // MARK: - Social Links

    func getSocialLinks(forceRefresh: Bool = false) async throws -> SocialLinks {
        if forceRefresh || !dataController.hasCachedData() {
            let links = try await firebaseService.fetchSocialLinks()
            try dataController.saveSocialLinks(links)
            return links
        }

        if let cachedLinks = try dataController.fetchSocialLinks() {
            return cachedLinks
        }

        // Fallback to Firebase
        let links = try await firebaseService.fetchSocialLinks()
        try dataController.saveSocialLinks(links)
        return links
    }

    // MARK: - Cache Management

    func clearCache() throws {
        try dataController.clearAllCache()
    }

    func hasCachedData() -> Bool {
        return dataController.hasCachedData()
    }
}
