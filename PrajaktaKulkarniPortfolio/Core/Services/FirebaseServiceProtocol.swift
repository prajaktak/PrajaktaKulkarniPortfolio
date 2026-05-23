//
//  FirebaseServiceProtocol.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation

/// Defines the interface for fetching CV data from a remote source.
/// Conforming to a protocol allows ViewModels and tests to use mocks instead of real Firebase.
/// All methods are @MainActor because the SwiftData @Model classes they return are non-Sendable
/// and all callers (ViewModels) are already main-actor-isolated.
protocol FirebaseServiceProtocol {
    @MainActor func fetchPersonalInfo() async throws -> PersonalInfo
    @MainActor func fetchWorkExperiences() async throws -> [WorkExperience]
    @MainActor func fetchEducation() async throws -> [Education]
    @MainActor func fetchSkills() async throws -> [Skill]
    @MainActor func fetchLanguages() async throws -> [Language]
    @MainActor func fetchCompetencies() async throws -> [Competency]
    @MainActor func fetchInterests() async throws -> [Interest]
    @MainActor func fetchProjects() async throws -> [Project]
    @MainActor func fetchSocialLinks() async throws -> SocialLinks
}
