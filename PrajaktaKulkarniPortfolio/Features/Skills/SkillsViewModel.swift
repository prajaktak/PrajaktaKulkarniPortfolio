// SkillsViewModel.swift
// PrajaktaKulkarniPortfolio
//
// Loads skills from Firebase, groups them by category,
// and sorts within each category by orderIndex.

import SwiftUI
import Observation

/// State manager for the Skills card.
/// Groups and sorts skills by category for display.
@Observable
@MainActor
final class SkillsViewModel {

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

    /// Skills grouped by category name, each group sorted by orderIndex
    private(set) var groupedSkills: [String: [Skill]] = [:]

    /// Category names sorted alphabetically
    private(set) var sortedCategories: [String] = []

    // MARK: - Dependencies

    private let firebaseService: any FirebaseServiceProtocol

    // MARK: - Init

    init(firebaseService: any FirebaseServiceProtocol = FirebaseService()) {
        self.firebaseService = firebaseService
    }

    // MARK: - Actions

    /// Fetches skills from Firebase and groups them by category.
    func loadSkills() async {
        viewState = .loading
        do {
            let fetched = try await firebaseService.fetchSkills()
            if fetched.isEmpty {
                groupedSkills = [:]
                sortedCategories = []
                viewState = .empty
            } else {
                let grouped = Dictionary(grouping: fetched, by: { $0.category })
                groupedSkills = grouped.mapValues { $0.sorted { $0.orderIndex < $1.orderIndex } }
                sortedCategories = groupedSkills.keys.sorted()
                viewState = .loaded
            }
        } catch {
            groupedSkills = [:]
            sortedCategories = []
            viewState = .error(error.localizedDescription)
        }
    }
}
