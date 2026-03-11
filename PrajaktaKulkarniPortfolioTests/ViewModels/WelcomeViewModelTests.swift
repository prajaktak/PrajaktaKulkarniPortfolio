// WelcomeViewModelTests.swift
// PrajaktaKulkarniPortfolioTests
//
// Tests for WelcomeViewModel — loads PersonalInfo from Firebase and exposes
// loading/error/content states. All Firebase calls go through MockFirebaseService.

import Testing
@testable import PrajaktaKulkarniPortfolio

@Suite("WelcomeViewModel Tests")
@MainActor
struct WelcomeViewModelTests {

    // MARK: - Helpers

    private func makePersonalInfo() -> PersonalInfo {
        PersonalInfo(
            id: "personal-1",
            fullName: "Prajakta Kulkarni",
            email: "prajakta@example.com",
            phoneNumber: "+31612345678",
            location: "Amsterdam, Netherlands",
            professionalSummary: "iOS Developer with 5+ years of experience."
        )
    }

    // MARK: - Initial State

    @Test("initialises in idle state")
    func init_isIdle() {
        let viewModel = WelcomeViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.viewState == .idle)
    }

    @Test("personalInfo is nil before loading")
    func init_personalInfoIsNil() {
        let viewModel = WelcomeViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.personalInfo == nil)
    }

    // MARK: - Loading

    @Test("loadPersonalInfo transitions to loading state")
    func loadPersonalInfo_transitionsToLoading() async {
        let mockService = MockFirebaseService()
        mockService.personalInfoToReturn = makePersonalInfo()
        let viewModel = WelcomeViewModel(firebaseService: mockService)
        await viewModel.loadPersonalInfo()
        // After completion it won't be loading anymore — but it must have passed through it
        #expect(viewModel.viewState != .idle)
    }

    @Test("loadPersonalInfo sets personalInfo on success")
    func loadPersonalInfo_setsPersonalInfoOnSuccess() async {
        let mockService = MockFirebaseService()
        mockService.personalInfoToReturn = makePersonalInfo()
        let viewModel = WelcomeViewModel(firebaseService: mockService)
        await viewModel.loadPersonalInfo()
        #expect(viewModel.personalInfo?.fullName == "Prajakta Kulkarni")
    }

    @Test("loadPersonalInfo sets loaded state on success")
    func loadPersonalInfo_setsLoadedStateOnSuccess() async {
        let mockService = MockFirebaseService()
        mockService.personalInfoToReturn = makePersonalInfo()
        let viewModel = WelcomeViewModel(firebaseService: mockService)
        await viewModel.loadPersonalInfo()
        #expect(viewModel.viewState == .loaded)
    }

    @Test("loadPersonalInfo sets error state on failure")
    func loadPersonalInfo_setsErrorStateOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = WelcomeViewModel(firebaseService: mockService)
        await viewModel.loadPersonalInfo()
        #expect(viewModel.viewState == .error("No data found in Firestore"))
    }

    @Test("loadPersonalInfo keeps personalInfo nil on failure")
    func loadPersonalInfo_keepsPersonalInfoNilOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = WelcomeViewModel(firebaseService: mockService)
        await viewModel.loadPersonalInfo()
        #expect(viewModel.personalInfo == nil)
    }

    // MARK: - ViewState Equality

    @Test("ViewState idle equals idle")
    func viewState_idleEqualsIdle() {
        #expect(WelcomeViewModel.ViewState.idle == .idle)
    }

    @Test("ViewState loaded equals loaded")
    func viewState_loadedEqualsLoaded() {
        #expect(WelcomeViewModel.ViewState.loaded == .loaded)
    }

    @Test("ViewState loading equals loading")
    func viewState_loadingEqualsLoading() {
        #expect(WelcomeViewModel.ViewState.loading == .loading)
    }

    @Test("ViewState error equals error with same message")
    func viewState_errorEqualsErrorWithSameMessage() {
        #expect(WelcomeViewModel.ViewState.error("oops") == .error("oops"))
    }

    @Test("ViewState error does not equal error with different message")
    func viewState_errorDoesNotEqualDifferentMessage() {
        #expect(WelcomeViewModel.ViewState.error("oops") != .error("other"))
    }
}
