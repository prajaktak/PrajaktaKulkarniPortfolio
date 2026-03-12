// InterestsViewModelTests.swift
// PrajaktaKulkarniPortfolioTests
//
// Tests for InterestsViewModel — loads Interest list from Firebase,
// sorts by orderIndex ascending.

import Testing
import Foundation
@testable import PrajaktaKulkarniPortfolio

@Suite("InterestsViewModel Tests")
@MainActor
struct InterestsViewModelTests {

    // MARK: - Helpers

    private func makeInterest(
        id: String = "int-1",
        interestTitle: String = "Cycling",
        interestDescription: String = "Road cycling on weekends",
        orderIndex: Int = 0
    ) -> Interest {
        Interest(
            id: id,
            interestTitle: interestTitle,
            interestDescription: interestDescription,
            orderIndex: orderIndex
        )
    }

    // MARK: - Initial State

    @Test("initialises in idle state")
    func init_isIdle() {
        let viewModel = InterestsViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.viewState == .idle)
    }

    @Test("interests is empty before loading")
    func init_interestsIsEmpty() {
        let viewModel = InterestsViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.interests.isEmpty)
    }

    // MARK: - Loading

    @Test("loadInterests sets loaded state on success")
    func loadInterests_setsLoadedStateOnSuccess() async {
        let mockService = MockFirebaseService()
        mockService.interestsToReturn = [makeInterest()]
        let viewModel = InterestsViewModel(firebaseService: mockService)
        await viewModel.loadInterests()
        #expect(viewModel.viewState == .loaded)
    }

    @Test("loadInterests populates interests on success")
    func loadInterests_populatesInterests() async {
        let mockService = MockFirebaseService()
        mockService.interestsToReturn = [makeInterest(id: "i1"), makeInterest(id: "i2")]
        let viewModel = InterestsViewModel(firebaseService: mockService)
        await viewModel.loadInterests()
        #expect(viewModel.interests.count == 2)
    }

    @Test("loadInterests sorts interests by orderIndex ascending")
    func loadInterests_sortsByOrderIndex() async {
        let mockService = MockFirebaseService()
        mockService.interestsToReturn = [
            makeInterest(id: "i2", orderIndex: 2),
            makeInterest(id: "i0", orderIndex: 0),
            makeInterest(id: "i1", orderIndex: 1)
        ]
        let viewModel = InterestsViewModel(firebaseService: mockService)
        await viewModel.loadInterests()
        #expect(viewModel.interests[0].id == "i0")
        #expect(viewModel.interests[1].id == "i1")
        #expect(viewModel.interests[2].id == "i2")
    }

    @Test("loadInterests sets empty state when no interests returned")
    func loadInterests_setsEmptyStateWhenNoData() async {
        let mockService = MockFirebaseService()
        mockService.interestsToReturn = []
        let viewModel = InterestsViewModel(firebaseService: mockService)
        await viewModel.loadInterests()
        #expect(viewModel.viewState == .empty)
    }

    @Test("loadInterests sets error state on failure")
    func loadInterests_setsErrorStateOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = InterestsViewModel(firebaseService: mockService)
        await viewModel.loadInterests()
        #expect(viewModel.viewState == .error("No data found in Firestore"))
    }

    @Test("loadInterests keeps interests empty on failure")
    func loadInterests_keepsInterestsEmptyOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = InterestsViewModel(firebaseService: mockService)
        await viewModel.loadInterests()
        #expect(viewModel.interests.isEmpty)
    }

    // MARK: - ViewState Equality

    @Test("ViewState idle equals idle")
    func viewState_idleEqualsIdle() {
        #expect(InterestsViewModel.ViewState.idle == .idle)
    }

    @Test("ViewState loaded equals loaded")
    func viewState_loadedEqualsLoaded() {
        #expect(InterestsViewModel.ViewState.loaded == .loaded)
    }

    @Test("ViewState empty equals empty")
    func viewState_emptyEqualsEmpty() {
        #expect(InterestsViewModel.ViewState.empty == .empty)
    }

    @Test("ViewState error equals error with same message")
    func viewState_errorEqualsErrorWithSameMessage() {
        #expect(InterestsViewModel.ViewState.error("oops") == .error("oops"))
    }
}
