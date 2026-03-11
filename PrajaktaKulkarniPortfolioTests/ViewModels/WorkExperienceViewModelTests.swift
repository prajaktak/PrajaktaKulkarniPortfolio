// WorkExperienceViewModelTests.swift
// PrajaktaKulkarniPortfolioTests
//
// Tests for WorkExperienceViewModel — loads WorkExperience list from Firebase,
// manages loading/error/content states, and sorts entries by orderIndex.

import Testing
import Foundation
@testable import PrajaktaKulkarniPortfolio

@Suite("WorkExperienceViewModel Tests")
@MainActor
struct WorkExperienceViewModelTests {

    // MARK: - Helpers

    private func makeExperience(
        id: String = "exp-1",
        companyName: String = "Acme Corp",
        jobTitle: String = "iOS Developer",
        startDate: Date = Date(timeIntervalSince1970: 1_600_000_000),
        endDate: Date? = nil,
        orderIndex: Int = 0
    ) -> WorkExperience {
        WorkExperience(
            id: id,
            companyName: companyName,
            jobTitle: jobTitle,
            startDate: startDate,
            endDate: endDate,
            hoursPerWeek: 40,
            jobDescription: "Built iOS apps.",
            technologiesUsed: ["Swift", "SwiftUI"],
            orderIndex: orderIndex
        )
    }

    // MARK: - Initial State

    @Test("initialises in idle state")
    func init_isIdle() {
        let viewModel = WorkExperienceViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.viewState == .idle)
    }

    @Test("experiences is empty before loading")
    func init_experiencesIsEmpty() {
        let viewModel = WorkExperienceViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.experiences.isEmpty)
    }

    // MARK: - Loading

    @Test("loadExperiences sets loaded state on success")
    func loadExperiences_setsLoadedStateOnSuccess() async {
        let mockService = MockFirebaseService()
        mockService.workExperiencesToReturn = [makeExperience()]
        let viewModel = WorkExperienceViewModel(firebaseService: mockService)
        await viewModel.loadExperiences()
        #expect(viewModel.viewState == .loaded)
    }

    @Test("loadExperiences populates experiences on success")
    func loadExperiences_populatesExperiencesOnSuccess() async {
        let mockService = MockFirebaseService()
        mockService.workExperiencesToReturn = [makeExperience(id: "exp-1"), makeExperience(id: "exp-2")]
        let viewModel = WorkExperienceViewModel(firebaseService: mockService)
        await viewModel.loadExperiences()
        #expect(viewModel.experiences.count == 2)
    }

    @Test("loadExperiences sorts experiences by orderIndex ascending")
    func loadExperiences_sortsByOrderIndex() async {
        let mockService = MockFirebaseService()
        mockService.workExperiencesToReturn = [
            makeExperience(id: "exp-2", orderIndex: 2),
            makeExperience(id: "exp-0", orderIndex: 0),
            makeExperience(id: "exp-1", orderIndex: 1)
        ]
        let viewModel = WorkExperienceViewModel(firebaseService: mockService)
        await viewModel.loadExperiences()
        #expect(viewModel.experiences[0].id == "exp-0")
        #expect(viewModel.experiences[1].id == "exp-1")
        #expect(viewModel.experiences[2].id == "exp-2")
    }

    @Test("loadExperiences sets error state on failure")
    func loadExperiences_setsErrorStateOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = WorkExperienceViewModel(firebaseService: mockService)
        await viewModel.loadExperiences()
        #expect(viewModel.viewState == .error("No data found in Firestore"))
    }

    @Test("loadExperiences keeps experiences empty on failure")
    func loadExperiences_keepsExperiencesEmptyOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = WorkExperienceViewModel(firebaseService: mockService)
        await viewModel.loadExperiences()
        #expect(viewModel.experiences.isEmpty)
    }

    @Test("loadExperiences sets empty state when no experiences returned")
    func loadExperiences_setsEmptyStateWhenNoData() async {
        let mockService = MockFirebaseService()
        mockService.workExperiencesToReturn = []
        let viewModel = WorkExperienceViewModel(firebaseService: mockService)
        await viewModel.loadExperiences()
        #expect(viewModel.viewState == .empty)
    }

    // MARK: - ViewState Equality

    @Test("ViewState idle equals idle")
    func viewState_idleEqualsIdle() {
        #expect(WorkExperienceViewModel.ViewState.idle == .idle)
    }

    @Test("ViewState loaded equals loaded")
    func viewState_loadedEqualsLoaded() {
        #expect(WorkExperienceViewModel.ViewState.loaded == .loaded)
    }

    @Test("ViewState empty equals empty")
    func viewState_emptyEqualsEmpty() {
        #expect(WorkExperienceViewModel.ViewState.empty == .empty)
    }

    @Test("ViewState error equals error with same message")
    func viewState_errorEqualsErrorWithSameMessage() {
        #expect(WorkExperienceViewModel.ViewState.error("oops") == .error("oops"))
    }
}
