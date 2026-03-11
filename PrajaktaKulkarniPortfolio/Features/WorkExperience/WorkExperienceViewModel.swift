// WorkExperienceViewModel.swift
// PrajaktaKulkarniPortfolio
//
// Loads the list of WorkExperience entries from Firebase and exposes
// them to WorkExperienceView sorted by orderIndex.

import SwiftUI
import Observation

/// State manager for the Work Experience card.
/// Fetches and sorts work experiences, managing loading, loaded, empty, and error states.
@Observable
@MainActor
final class WorkExperienceViewModel {

    // MARK: - Nested Types

    /// Represents the possible UI states of the Work Experience card.
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }

    // MARK: - State

    /// Current UI state
    private(set) var viewState: ViewState = .idle

    /// Sorted list of work experiences, non-empty when viewState is .loaded
    private(set) var experiences: [WorkExperience] = []

    // MARK: - Dependencies

    private let firebaseService: any FirebaseServiceProtocol

    // MARK: - Init

    init(firebaseService: any FirebaseServiceProtocol = FirebaseService()) {
        self.firebaseService = firebaseService
    }

    // MARK: - Actions

    /// Fetches and sorts work experiences from Firebase.
    func loadExperiences() async {
        viewState = .loading
        do {
            let fetched = try await firebaseService.fetchWorkExperiences()
            if fetched.isEmpty {
                experiences = []
                viewState = .empty
            } else {
                experiences = fetched.sorted { $0.orderIndex < $1.orderIndex }
                viewState = .loaded
            }
        } catch {
            experiences = []
            viewState = .error(error.localizedDescription)
        }
    }
}
