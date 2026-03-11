// EducationViewModel.swift
// PrajaktaKulkarniPortfolio
//
// Loads education entries from Firebase and sorts them by orderIndex.

import SwiftUI
import Observation

/// State manager for the Education card.
/// Fetches and sorts education entries, managing loading, loaded, empty, and error states.
@Observable
@MainActor
final class EducationViewModel {

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

    /// Sorted list of education entries, non-empty when viewState is .loaded
    private(set) var educationEntries: [Education] = []

    // MARK: - Dependencies

    private let firebaseService: any FirebaseServiceProtocol

    // MARK: - Init

    init(firebaseService: any FirebaseServiceProtocol = FirebaseService()) {
        self.firebaseService = firebaseService
    }

    // MARK: - Actions

    /// Fetches and sorts education entries from Firebase.
    func loadEducation() async {
        viewState = .loading
        do {
            let fetched = try await firebaseService.fetchEducation()
            if fetched.isEmpty {
                educationEntries = []
                viewState = .empty
            } else {
                educationEntries = fetched.sorted { $0.orderIndex < $1.orderIndex }
                viewState = .loaded
            }
        } catch {
            educationEntries = []
            viewState = .error(error.localizedDescription)
        }
    }
}
