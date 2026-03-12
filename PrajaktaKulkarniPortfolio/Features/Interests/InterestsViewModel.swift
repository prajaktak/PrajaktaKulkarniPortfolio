// InterestsViewModel.swift
// PrajaktaKulkarniPortfolio
//
// Loads interests from Firebase and sorts them by orderIndex ascending.

import SwiftUI
import Observation

/// State manager for the Interests card.
/// Sorts interests by orderIndex for display.
@Observable
@MainActor
final class InterestsViewModel {

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

    /// Interests sorted by orderIndex ascending
    private(set) var interests: [Interest] = []

    // MARK: - Dependencies

    private let firebaseService: any FirebaseServiceProtocol

    // MARK: - Init

    init(firebaseService: any FirebaseServiceProtocol = FirebaseService()) {
        self.firebaseService = firebaseService
    }

    // MARK: - Actions

    /// Fetches interests from Firebase and sorts them by orderIndex.
    func loadInterests() async {
        viewState = .loading
        do {
            let fetched = try await firebaseService.fetchInterests()
            if fetched.isEmpty {
                interests = []
                viewState = .empty
            } else {
                interests = fetched.sorted { $0.orderIndex < $1.orderIndex }
                viewState = .loaded
            }
        } catch {
            interests = []
            viewState = .error(error.localizedDescription)
        }
    }
}
