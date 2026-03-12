// CompetenciesViewModel.swift
// PrajaktaKulkarniPortfolio
//
// Loads competencies and languages from Firebase.
// Competencies are sorted by orderIndex ascending.
// Languages are displayed as-is.

import SwiftUI
import Observation

/// State manager for the Competencies & Languages card.
/// Fetches both competencies and languages in parallel.
@Observable
@MainActor
final class CompetenciesViewModel {

    // MARK: - Nested Types

    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }

    // MARK: - State

    private(set) var viewState: ViewState = .idle

    /// Competencies sorted by orderIndex ascending
    private(set) var competencies: [Competency] = []

    /// Languages in the order returned by Firebase
    private(set) var languages: [Language] = []

    // MARK: - Dependencies

    private let firebaseService: any FirebaseServiceProtocol

    // MARK: - Init

    init(firebaseService: any FirebaseServiceProtocol = FirebaseService()) {
        self.firebaseService = firebaseService
    }

    // MARK: - Actions

    /// Fetches competencies and languages from Firebase concurrently.
    func loadContent() async {
        viewState = .loading
        do {
            async let fetchedCompetencies = firebaseService.fetchCompetencies()
            async let fetchedLanguages = firebaseService.fetchLanguages()
            let (comps, langs) = try await (fetchedCompetencies, fetchedLanguages)

            competencies = comps.sorted { $0.orderIndex < $1.orderIndex }
            languages = langs

            if competencies.isEmpty && languages.isEmpty {
                viewState = .empty
            } else {
                viewState = .loaded
            }
        } catch {
            competencies = []
            languages = []
            viewState = .error(error.localizedDescription)
        }
    }
}
