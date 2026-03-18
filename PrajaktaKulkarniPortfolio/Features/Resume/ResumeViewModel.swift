// ResumeViewModel.swift
// PrajaktaKulkarniPortfolio
//
// Fetches all data needed to render the resume screen from Firebase in parallel.

import SwiftUI
import Observation

@Observable
@MainActor
final class ResumeViewModel {

    // MARK: - View State

    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
    }

    private(set) var viewState: ViewState = .idle

    // MARK: - Data

    private(set) var personalInfo: PersonalInfo?
    private(set) var skills: [Skill] = []
    private(set) var languages: [Language] = []
    private(set) var experiences: [WorkExperience] = []
    private(set) var projects: [Project] = []
    private(set) var socialLinks: SocialLinks?

    // MARK: - Dependencies

    private let firebaseService: any FirebaseServiceProtocol

    init(firebaseService: any FirebaseServiceProtocol = FirebaseService()) {
        self.firebaseService = firebaseService
    }

    // MARK: - Load

    func loadAll() async {
        viewState = .loading
        do {
            async let infoFetch     = firebaseService.fetchPersonalInfo()
            async let skillsFetch   = firebaseService.fetchSkills()
            async let langFetch     = firebaseService.fetchLanguages()
            async let expFetch      = firebaseService.fetchWorkExperiences()
            async let projFetch     = firebaseService.fetchProjects()
            async let linksFetch    = firebaseService.fetchSocialLinks()

            personalInfo = try await infoFetch
            skills       = try await skillsFetch
            languages    = try await langFetch
            experiences  = try await expFetch
            projects     = try await projFetch
            socialLinks  = try? await linksFetch
            viewState    = .loaded
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }

    // MARK: - Helpers

    func dateString(from date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMM yyyy"
        return f.string(from: date)
    }

    func dateRange(start: Date, end: Date?) -> String {
        "\(dateString(from: start)) – \(end.map { dateString(from: $0) } ?? "Present")"
    }
}
