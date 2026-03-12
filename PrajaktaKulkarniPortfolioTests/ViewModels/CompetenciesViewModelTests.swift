// CompetenciesViewModelTests.swift
// PrajaktaKulkarniPortfolioTests
//
// Tests for CompetenciesViewModel — loads Competency and Language lists
// from Firebase and sorts competencies by orderIndex ascending.

import Testing
import Foundation
@testable import PrajaktaKulkarniPortfolio

@Suite("CompetenciesViewModel Tests")
@MainActor
struct CompetenciesViewModelTests {

    // MARK: - Helpers

    private func makeCompetency(
        id: String = "comp-1",
        competencyTitle: String = "Teamwork",
        competencyDescription: String = "Collaboration and teamwork",
        orderIndex: Int = 0
    ) -> Competency {
        Competency(
            id: id,
            competencyTitle: competencyTitle,
            competencyDescription: competencyDescription,
            orderIndex: orderIndex
        )
    }

    private func makeLanguage(
        id: String = "lang-1",
        languageName: String = "English",
        speakingProficiency: String = "Good",
        writingProficiency: String = "Good"
    ) -> Language {
        Language(
            id: id,
            languageName: languageName,
            speakingProficiency: speakingProficiency,
            writingProficiency: writingProficiency
        )
    }

    // MARK: - Initial State

    @Test("initialises in idle state")
    func init_isIdle() {
        let viewModel = CompetenciesViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.viewState == .idle)
    }

    @Test("competencies is empty before loading")
    func init_competenciesIsEmpty() {
        let viewModel = CompetenciesViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.competencies.isEmpty)
    }

    @Test("languages is empty before loading")
    func init_languagesIsEmpty() {
        let viewModel = CompetenciesViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.languages.isEmpty)
    }

    // MARK: - Loading

    @Test("loadContent sets loaded state when competencies and languages succeed")
    func loadContent_setsLoadedState() async {
        let mockService = MockFirebaseService()
        mockService.competenciesToReturn = [makeCompetency()]
        mockService.languagesToReturn = [makeLanguage()]
        let viewModel = CompetenciesViewModel(firebaseService: mockService)
        await viewModel.loadContent()
        #expect(viewModel.viewState == .loaded)
    }

    @Test("loadContent populates competencies on success")
    func loadContent_populatesCompetencies() async {
        let mockService = MockFirebaseService()
        mockService.competenciesToReturn = [makeCompetency(id: "c1"), makeCompetency(id: "c2")]
        mockService.languagesToReturn = []
        let viewModel = CompetenciesViewModel(firebaseService: mockService)
        await viewModel.loadContent()
        #expect(viewModel.competencies.count == 2)
    }

    @Test("loadContent populates languages on success")
    func loadContent_populatesLanguages() async {
        let mockService = MockFirebaseService()
        mockService.competenciesToReturn = []
        mockService.languagesToReturn = [makeLanguage(id: "l1"), makeLanguage(id: "l2")]
        let viewModel = CompetenciesViewModel(firebaseService: mockService)
        await viewModel.loadContent()
        #expect(viewModel.languages.count == 2)
    }

    @Test("loadContent sorts competencies by orderIndex ascending")
    func loadContent_sortsCompetenciesByOrderIndex() async {
        let mockService = MockFirebaseService()
        mockService.competenciesToReturn = [
            makeCompetency(id: "c2", orderIndex: 2),
            makeCompetency(id: "c0", orderIndex: 0),
            makeCompetency(id: "c1", orderIndex: 1)
        ]
        mockService.languagesToReturn = []
        let viewModel = CompetenciesViewModel(firebaseService: mockService)
        await viewModel.loadContent()
        #expect(viewModel.competencies[0].id == "c0")
        #expect(viewModel.competencies[1].id == "c1")
        #expect(viewModel.competencies[2].id == "c2")
    }

    @Test("loadContent sets empty state when both lists are empty")
    func loadContent_setsEmptyStateWhenBothEmpty() async {
        let mockService = MockFirebaseService()
        mockService.competenciesToReturn = []
        mockService.languagesToReturn = []
        let viewModel = CompetenciesViewModel(firebaseService: mockService)
        await viewModel.loadContent()
        #expect(viewModel.viewState == .empty)
    }

    @Test("loadContent sets loaded state when only competencies are present")
    func loadContent_setsLoadedWhenOnlyCompetencies() async {
        let mockService = MockFirebaseService()
        mockService.competenciesToReturn = [makeCompetency()]
        mockService.languagesToReturn = []
        let viewModel = CompetenciesViewModel(firebaseService: mockService)
        await viewModel.loadContent()
        #expect(viewModel.viewState == .loaded)
    }

    @Test("loadContent sets loaded state when only languages are present")
    func loadContent_setsLoadedWhenOnlyLanguages() async {
        let mockService = MockFirebaseService()
        mockService.competenciesToReturn = []
        mockService.languagesToReturn = [makeLanguage()]
        let viewModel = CompetenciesViewModel(firebaseService: mockService)
        await viewModel.loadContent()
        #expect(viewModel.viewState == .loaded)
    }

    @Test("loadContent sets error state on failure")
    func loadContent_setsErrorStateOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = CompetenciesViewModel(firebaseService: mockService)
        await viewModel.loadContent()
        #expect(viewModel.viewState == .error("No data found in Firestore"))
    }

    @Test("loadContent keeps competencies empty on failure")
    func loadContent_keepsCompetenciesEmptyOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = CompetenciesViewModel(firebaseService: mockService)
        await viewModel.loadContent()
        #expect(viewModel.competencies.isEmpty)
    }

    @Test("loadContent keeps languages empty on failure")
    func loadContent_keepsLanguagesEmptyOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = CompetenciesViewModel(firebaseService: mockService)
        await viewModel.loadContent()
        #expect(viewModel.languages.isEmpty)
    }

    // MARK: - ViewState Equality

    @Test("ViewState idle equals idle")
    func viewState_idleEqualsIdle() {
        #expect(CompetenciesViewModel.ViewState.idle == .idle)
    }

    @Test("ViewState loaded equals loaded")
    func viewState_loadedEqualsLoaded() {
        #expect(CompetenciesViewModel.ViewState.loaded == .loaded)
    }

    @Test("ViewState empty equals empty")
    func viewState_emptyEqualsEmpty() {
        #expect(CompetenciesViewModel.ViewState.empty == .empty)
    }

    @Test("ViewState error equals error with same message")
    func viewState_errorEqualsErrorWithSameMessage() {
        #expect(CompetenciesViewModel.ViewState.error("oops") == .error("oops"))
    }
}
