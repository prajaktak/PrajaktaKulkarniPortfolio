// WelcomeViewModel.swift
// PrajaktaKulkarniPortfolio
//
// Loads PersonalInfo from Firebase and exposes it to WelcomeView.
// Uses FirebaseServiceProtocol for testability via dependency injection.

import SwiftUI
import Observation

/// State manager for the Welcome/About card.
/// Fetches PersonalInfo and manages loading, loaded, and error states.
@Observable
@MainActor
final class WelcomeViewModel {

    // MARK: - Nested Types

    /// Represents the possible UI states of the Welcome card.
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
    }

    // MARK: - State

    /// Current UI state of the view
    private(set) var viewState: ViewState = .idle

    /// The loaded personal info, non-nil when viewState is .loaded
    private(set) var personalInfo: PersonalInfo?

    // MARK: - Dependencies

    private let firebaseService: any FirebaseServiceProtocol

    // MARK: - Init

    init(firebaseService: any FirebaseServiceProtocol = FirebaseService()) {
        self.firebaseService = firebaseService
    }

    // MARK: - Actions

    /// Fetches PersonalInfo from Firebase. Updates viewState accordingly.
    func loadPersonalInfo() async {
        viewState = .loading
        do {
            let info = try await firebaseService.fetchPersonalInfo()
            personalInfo = info
            viewState = .loaded
        } catch {
            personalInfo = nil
            viewState = .error(error.localizedDescription)
        }
    }
}
