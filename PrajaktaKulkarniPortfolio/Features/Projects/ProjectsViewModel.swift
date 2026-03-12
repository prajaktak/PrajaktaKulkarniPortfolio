// ProjectsViewModel.swift
// PrajaktaKulkarniPortfolio
//
// Loads projects from Firebase, sorts by orderIndex ascending,
// and surfaces the featured project (if any) separately.

import SwiftUI
import Observation

/// State manager for the Projects card.
/// Sorts all projects by orderIndex and exposes the featured project.
@Observable
@MainActor
final class ProjectsViewModel {

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

    /// All projects sorted by orderIndex ascending
    private(set) var projects: [Project] = []

    /// The project marked as featured, or nil if none
    private(set) var featuredProject: Project?

    // MARK: - Dependencies

    private let firebaseService: any FirebaseServiceProtocol

    // MARK: - Init

    init(firebaseService: any FirebaseServiceProtocol = FirebaseService()) {
        self.firebaseService = firebaseService
    }

    // MARK: - Actions

    /// Fetches projects from Firebase, sorts them, and identifies the featured project.
    func loadProjects() async {
        viewState = .loading
        do {
            let fetched = try await firebaseService.fetchProjects()
            if fetched.isEmpty {
                projects = []
                featuredProject = nil
                viewState = .empty
            } else {
                projects = fetched.sorted { $0.orderIndex < $1.orderIndex }
                featuredProject = projects.first { $0.isFeatured }
                viewState = .loaded
            }
        } catch {
            projects = []
            featuredProject = nil
            viewState = .error(error.localizedDescription)
        }
    }
}
