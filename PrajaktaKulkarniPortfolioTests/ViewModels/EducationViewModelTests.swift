// EducationViewModelTests.swift
// PrajaktaKulkarniPortfolioTests
//
// Tests for EducationViewModel — loads Education list from Firebase,
// sorts by orderIndex ascending.

import Testing
import Foundation
@testable import PrajaktaKulkarniPortfolio

@Suite("EducationViewModel Tests")
@MainActor
struct EducationViewModelTests {

    // MARK: - Helpers

    private func makeEducation(
        id: String = "edu-1",
        degreeName: String = "Bachelor of Science",
        fieldOfStudy: String = "Computer Science",
        institutionName: String = "University of Amsterdam",
        orderIndex: Int = 0
    ) -> Education {
        Education(
            id: id,
            degreeName: degreeName,
            fieldOfStudy: fieldOfStudy,
            institutionName: institutionName,
            startDate: Date(timeIntervalSince1970: 1_400_000_000),
            endDate: Date(timeIntervalSince1970: 1_530_000_000),
            subjectsStudied: "Algorithms, Data Structures, iOS Development",
            hasDiploma: true,
            orderIndex: orderIndex
        )
    }

    // MARK: - Initial State

    @Test("initialises in idle state")
    func init_isIdle() {
        let viewModel = EducationViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.viewState == .idle)
    }

    @Test("educationEntries is empty before loading")
    func init_educationEntriesIsEmpty() {
        let viewModel = EducationViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.educationEntries.isEmpty)
    }

    // MARK: - Loading

    @Test("loadEducation sets loaded state on success")
    func loadEducation_setsLoadedStateOnSuccess() async {
        let mockService = MockFirebaseService()
        mockService.educationToReturn = [makeEducation()]
        let viewModel = EducationViewModel(firebaseService: mockService)
        await viewModel.loadEducation()
        #expect(viewModel.viewState == .loaded)
    }

    @Test("loadEducation populates educationEntries on success")
    func loadEducation_populatesEntriesOnSuccess() async {
        let mockService = MockFirebaseService()
        mockService.educationToReturn = [makeEducation(id: "edu-1"), makeEducation(id: "edu-2")]
        let viewModel = EducationViewModel(firebaseService: mockService)
        await viewModel.loadEducation()
        #expect(viewModel.educationEntries.count == 2)
    }

    @Test("loadEducation sorts entries by orderIndex ascending")
    func loadEducation_sortsByOrderIndex() async {
        let mockService = MockFirebaseService()
        mockService.educationToReturn = [
            makeEducation(id: "edu-2", orderIndex: 2),
            makeEducation(id: "edu-0", orderIndex: 0),
            makeEducation(id: "edu-1", orderIndex: 1)
        ]
        let viewModel = EducationViewModel(firebaseService: mockService)
        await viewModel.loadEducation()
        #expect(viewModel.educationEntries[0].id == "edu-0")
        #expect(viewModel.educationEntries[1].id == "edu-1")
        #expect(viewModel.educationEntries[2].id == "edu-2")
    }

    @Test("loadEducation sets error state on failure")
    func loadEducation_setsErrorStateOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = EducationViewModel(firebaseService: mockService)
        await viewModel.loadEducation()
        #expect(viewModel.viewState == .error("No data found in Firestore"))
    }

    @Test("loadEducation keeps entries empty on failure")
    func loadEducation_keepsEntriesEmptyOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = EducationViewModel(firebaseService: mockService)
        await viewModel.loadEducation()
        #expect(viewModel.educationEntries.isEmpty)
    }

    @Test("loadEducation sets empty state when no entries returned")
    func loadEducation_setsEmptyStateWhenNoData() async {
        let mockService = MockFirebaseService()
        mockService.educationToReturn = []
        let viewModel = EducationViewModel(firebaseService: mockService)
        await viewModel.loadEducation()
        #expect(viewModel.viewState == .empty)
    }

    // MARK: - ViewState Equality

    @Test("ViewState idle equals idle")
    func viewState_idleEqualsIdle() {
        #expect(EducationViewModel.ViewState.idle == .idle)
    }

    @Test("ViewState loaded equals loaded")
    func viewState_loadedEqualsLoaded() {
        #expect(EducationViewModel.ViewState.loaded == .loaded)
    }

    @Test("ViewState empty equals empty")
    func viewState_emptyEqualsEmpty() {
        #expect(EducationViewModel.ViewState.empty == .empty)
    }

    @Test("ViewState error equals error with same message")
    func viewState_errorEqualsErrorWithSameMessage() {
        #expect(EducationViewModel.ViewState.error("oops") == .error("oops"))
    }
}
