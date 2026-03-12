// ProjectsViewModelTests.swift
// PrajaktaKulkarniPortfolioTests
//
// Tests for ProjectsViewModel — loads Project list from Firebase,
// sorts by orderIndex ascending, surfaces the featured project.

import Testing
import Foundation
@testable import PrajaktaKulkarniPortfolio

@Suite("ProjectsViewModel Tests")
@MainActor
struct ProjectsViewModelTests {

    // MARK: - Helpers

    private func makeProject(
        id: String = "proj-1",
        title: String = "Sequence Game",
        orderIndex: Int = 0,
        isFeatured: Bool = false,
        endDate: Date? = nil
    ) -> Project {
        Project(
            id: id,
            title: title,
            startDate: Date(timeIntervalSince1970: 1_700_000_000),
            endDate: endDate,
            projectDescription: "A test project",
            techStack: ["Swift", "SwiftUI"],
            githubURL: "https://github.com/prajakta/test",
            screenshotURLs: [],
            demoVideoURL: nil,
            isFeatured: isFeatured,
            orderIndex: orderIndex
        )
    }

    // MARK: - Initial State

    @Test("initialises in idle state")
    func init_isIdle() {
        let viewModel = ProjectsViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.viewState == .idle)
    }

    @Test("projects is empty before loading")
    func init_projectsIsEmpty() {
        let viewModel = ProjectsViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.projects.isEmpty)
    }

    @Test("featuredProject is nil before loading")
    func init_featuredProjectIsNil() {
        let viewModel = ProjectsViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.featuredProject == nil)
    }

    // MARK: - Loading

    @Test("loadProjects sets loaded state on success")
    func loadProjects_setsLoadedStateOnSuccess() async {
        let mockService = MockFirebaseService()
        mockService.projectsToReturn = [makeProject()]
        let viewModel = ProjectsViewModel(firebaseService: mockService)
        await viewModel.loadProjects()
        #expect(viewModel.viewState == .loaded)
    }

    @Test("loadProjects populates projects on success")
    func loadProjects_populatesProjects() async {
        let mockService = MockFirebaseService()
        mockService.projectsToReturn = [makeProject(id: "p1"), makeProject(id: "p2")]
        let viewModel = ProjectsViewModel(firebaseService: mockService)
        await viewModel.loadProjects()
        #expect(viewModel.projects.count == 2)
    }

    @Test("loadProjects sorts projects by orderIndex ascending")
    func loadProjects_sortsByOrderIndex() async {
        let mockService = MockFirebaseService()
        mockService.projectsToReturn = [
            makeProject(id: "p2", orderIndex: 2),
            makeProject(id: "p0", orderIndex: 0),
            makeProject(id: "p1", orderIndex: 1)
        ]
        let viewModel = ProjectsViewModel(firebaseService: mockService)
        await viewModel.loadProjects()
        #expect(viewModel.projects[0].id == "p0")
        #expect(viewModel.projects[1].id == "p1")
        #expect(viewModel.projects[2].id == "p2")
    }

    @Test("loadProjects sets featuredProject when one project is featured")
    func loadProjects_setsFeaturedProject() async {
        let mockService = MockFirebaseService()
        mockService.projectsToReturn = [
            makeProject(id: "p1", isFeatured: false),
            makeProject(id: "featured", isFeatured: true)
        ]
        let viewModel = ProjectsViewModel(firebaseService: mockService)
        await viewModel.loadProjects()
        #expect(viewModel.featuredProject?.id == "featured")
    }

    @Test("loadProjects featuredProject is nil when no project is featured")
    func loadProjects_featuredProjectIsNilWhenNoneFeatured() async {
        let mockService = MockFirebaseService()
        mockService.projectsToReturn = [
            makeProject(id: "p1", isFeatured: false),
            makeProject(id: "p2", isFeatured: false)
        ]
        let viewModel = ProjectsViewModel(firebaseService: mockService)
        await viewModel.loadProjects()
        #expect(viewModel.featuredProject == nil)
    }

    @Test("loadProjects sets empty state when no projects returned")
    func loadProjects_setsEmptyStateWhenNoData() async {
        let mockService = MockFirebaseService()
        mockService.projectsToReturn = []
        let viewModel = ProjectsViewModel(firebaseService: mockService)
        await viewModel.loadProjects()
        #expect(viewModel.viewState == .empty)
    }

    @Test("loadProjects sets error state on failure")
    func loadProjects_setsErrorStateOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = ProjectsViewModel(firebaseService: mockService)
        await viewModel.loadProjects()
        #expect(viewModel.viewState == .error("No data found in Firestore"))
    }

    @Test("loadProjects keeps projects empty on failure")
    func loadProjects_keepsProjectsEmptyOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = ProjectsViewModel(firebaseService: mockService)
        await viewModel.loadProjects()
        #expect(viewModel.projects.isEmpty)
    }

    @Test("loadProjects keeps featuredProject nil on failure")
    func loadProjects_keepsFeaturedProjectNilOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = ProjectsViewModel(firebaseService: mockService)
        await viewModel.loadProjects()
        #expect(viewModel.featuredProject == nil)
    }

    @Test("project with nil endDate is ongoing")
    func project_nilEndDate_isOngoing() async {
        let mockService = MockFirebaseService()
        mockService.projectsToReturn = [makeProject(endDate: nil)]
        let viewModel = ProjectsViewModel(firebaseService: mockService)
        await viewModel.loadProjects()
        #expect(viewModel.projects.first?.isOngoing == true)
    }

    @Test("project with endDate is not ongoing")
    func project_withEndDate_isNotOngoing() async {
        let mockService = MockFirebaseService()
        mockService.projectsToReturn = [makeProject(endDate: Date(timeIntervalSince1970: 1_800_000_000))]
        let viewModel = ProjectsViewModel(firebaseService: mockService)
        await viewModel.loadProjects()
        #expect(viewModel.projects.first?.isOngoing == false)
    }

    // MARK: - ViewState Equality

    @Test("ViewState idle equals idle")
    func viewState_idleEqualsIdle() {
        #expect(ProjectsViewModel.ViewState.idle == .idle)
    }

    @Test("ViewState loaded equals loaded")
    func viewState_loadedEqualsLoaded() {
        #expect(ProjectsViewModel.ViewState.loaded == .loaded)
    }

    @Test("ViewState empty equals empty")
    func viewState_emptyEqualsEmpty() {
        #expect(ProjectsViewModel.ViewState.empty == .empty)
    }

    @Test("ViewState error equals error with same message")
    func viewState_errorEqualsErrorWithSameMessage() {
        #expect(ProjectsViewModel.ViewState.error("oops") == .error("oops"))
    }
}
