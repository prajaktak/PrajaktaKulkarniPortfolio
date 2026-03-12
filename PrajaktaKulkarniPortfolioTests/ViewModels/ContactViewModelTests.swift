// ContactViewModelTests.swift
// PrajaktaKulkarniPortfolioTests
//
// Tests for ContactViewModel — loads SocialLinks from Firebase
// and exposes LinkedIn, GitHub, and email as tappable links.

import Testing
import Foundation
@testable import PrajaktaKulkarniPortfolio

@Suite("ContactViewModel Tests")
@MainActor
struct ContactViewModelTests {

    // MARK: - Helpers

    private func makeSocialLinks(
        id: String = "sl-1",
        linkedInURL: String = "https://linkedin.com/in/prajakta",
        githubURL: String = "https://github.com/prajaktak",
        emailAddress: String = "prachee.j@gmail.com"
    ) -> SocialLinks {
        SocialLinks(
            id: id,
            linkedInURL: linkedInURL,
            githubURL: githubURL,
            emailAddress: emailAddress
        )
    }

    // MARK: - Initial State

    @Test("initialises in idle state")
    func init_isIdle() {
        let viewModel = ContactViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.viewState == .idle)
    }

    @Test("socialLinks is nil before loading")
    func init_socialLinksIsNil() {
        let viewModel = ContactViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.socialLinks == nil)
    }

    // MARK: - Loading

    @Test("loadContact sets loaded state on success")
    func loadContact_setsLoadedStateOnSuccess() async {
        let mockService = MockFirebaseService()
        mockService.socialLinksToReturn = makeSocialLinks()
        let viewModel = ContactViewModel(firebaseService: mockService)
        await viewModel.loadContact()
        #expect(viewModel.viewState == .loaded)
    }

    @Test("loadContact populates socialLinks on success")
    func loadContact_populatesSocialLinks() async {
        let mockService = MockFirebaseService()
        mockService.socialLinksToReturn = makeSocialLinks()
        let viewModel = ContactViewModel(firebaseService: mockService)
        await viewModel.loadContact()
        #expect(viewModel.socialLinks != nil)
    }

    @Test("loadContact exposes correct LinkedIn URL")
    func loadContact_exposesLinkedInURL() async {
        let mockService = MockFirebaseService()
        mockService.socialLinksToReturn = makeSocialLinks(linkedInURL: "https://linkedin.com/in/prajakta")
        let viewModel = ContactViewModel(firebaseService: mockService)
        await viewModel.loadContact()
        #expect(viewModel.socialLinks?.linkedInURL == "https://linkedin.com/in/prajakta")
    }

    @Test("loadContact exposes correct GitHub URL")
    func loadContact_exposesGitHubURL() async {
        let mockService = MockFirebaseService()
        mockService.socialLinksToReturn = makeSocialLinks(githubURL: "https://github.com/prajaktak")
        let viewModel = ContactViewModel(firebaseService: mockService)
        await viewModel.loadContact()
        #expect(viewModel.socialLinks?.githubURL == "https://github.com/prajaktak")
    }

    @Test("loadContact exposes correct email address")
    func loadContact_exposesEmailAddress() async {
        let mockService = MockFirebaseService()
        mockService.socialLinksToReturn = makeSocialLinks(emailAddress: "prachee.j@gmail.com")
        let viewModel = ContactViewModel(firebaseService: mockService)
        await viewModel.loadContact()
        #expect(viewModel.socialLinks?.emailAddress == "prachee.j@gmail.com")
    }

    @Test("loadContact sets error state on failure")
    func loadContact_setsErrorStateOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = ContactViewModel(firebaseService: mockService)
        await viewModel.loadContact()
        #expect(viewModel.viewState == .error("No data found in Firestore"))
    }

    @Test("loadContact keeps socialLinks nil on failure")
    func loadContact_keepsSocialLinksNilOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = ContactViewModel(firebaseService: mockService)
        await viewModel.loadContact()
        #expect(viewModel.socialLinks == nil)
    }

    @Test("loadContact sets error state when no data configured")
    func loadContact_setsErrorWhenNoDataConfigured() async {
        let mockService = MockFirebaseService()
        mockService.socialLinksToReturn = nil
        let viewModel = ContactViewModel(firebaseService: mockService)
        await viewModel.loadContact()
        if case .error = viewModel.viewState {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected error state")
        }
    }

    // MARK: - ViewState Equality

    @Test("ViewState idle equals idle")
    func viewState_idleEqualsIdle() {
        #expect(ContactViewModel.ViewState.idle == .idle)
    }

    @Test("ViewState loaded equals loaded")
    func viewState_loadedEqualsLoaded() {
        #expect(ContactViewModel.ViewState.loaded == .loaded)
    }

    @Test("ViewState error equals error with same message")
    func viewState_errorEqualsErrorWithSameMessage() {
        #expect(ContactViewModel.ViewState.error("oops") == .error("oops"))
    }
}
