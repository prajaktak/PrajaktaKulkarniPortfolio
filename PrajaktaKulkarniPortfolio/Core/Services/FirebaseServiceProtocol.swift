//
//  FirebaseServiceProtocol.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation

/// Defines the interface for fetching CV data from a remote source.
/// Conforming to a protocol allows ViewModels and tests to use mocks instead of real Firebase.
protocol FirebaseServiceProtocol {
    func fetchPersonalInfo() async throws -> PersonalInfo
    func fetchWorkExperiences() async throws -> [WorkExperience]
    func fetchEducation() async throws -> [Education]
    func fetchSkills() async throws -> [Skill]
    func fetchLanguages() async throws -> [Language]
    func fetchCompetencies() async throws -> [Competency]
    func fetchInterests() async throws -> [Interest]
    func fetchProjects() async throws -> [Project]
    func fetchSocialLinks() async throws -> SocialLinks
}
