// SkillsViewModelTests.swift
// PrajaktaKulkarniPortfolioTests
//
// Tests for SkillsViewModel — loads Skill list from Firebase,
// groups by category, sorts within each category by orderIndex.

import Testing
@testable import PrajaktaKulkarniPortfolio

@Suite("SkillsViewModel Tests")
@MainActor
struct SkillsViewModelTests {

    // MARK: - Helpers

    private func makeSkill(
        id: String = "skill-1",
        skillName: String = "Swift",
        category: String = "Languages",
        orderIndex: Int = 0
    ) -> Skill {
        Skill(id: id, skillName: skillName, category: category, proficiencyLevel: "Expert", orderIndex: orderIndex)
    }

    // MARK: - Initial State

    @Test("initialises in idle state")
    func init_isIdle() {
        let viewModel = SkillsViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.viewState == .idle)
    }

    @Test("groupedSkills is empty before loading")
    func init_groupedSkillsIsEmpty() {
        let viewModel = SkillsViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.groupedSkills.isEmpty)
    }

    @Test("sortedCategories is empty before loading")
    func init_sortedCategoriesIsEmpty() {
        let viewModel = SkillsViewModel(firebaseService: MockFirebaseService())
        #expect(viewModel.sortedCategories.isEmpty)
    }

    // MARK: - Loading

    @Test("loadSkills sets loaded state on success")
    func loadSkills_setsLoadedStateOnSuccess() async {
        let mockService = MockFirebaseService()
        mockService.skillsToReturn = [makeSkill()]
        let viewModel = SkillsViewModel(firebaseService: mockService)
        await viewModel.loadSkills()
        #expect(viewModel.viewState == .loaded)
    }

    @Test("loadSkills groups skills by category")
    func loadSkills_groupsByCategory() async {
        let mockService = MockFirebaseService()
        mockService.skillsToReturn = [
            makeSkill(id: "s1", skillName: "Swift", category: "Languages"),
            makeSkill(id: "s2", skillName: "Python", category: "Languages"),
            makeSkill(id: "s3", skillName: "SwiftUI", category: "Frameworks")
        ]
        let viewModel = SkillsViewModel(firebaseService: mockService)
        await viewModel.loadSkills()
        #expect(viewModel.groupedSkills["Languages"]?.count == 2)
        #expect(viewModel.groupedSkills["Frameworks"]?.count == 1)
    }

    @Test("loadSkills sorts skills within category by orderIndex")
    func loadSkills_sortsWithinCategoryByOrderIndex() async {
        let mockService = MockFirebaseService()
        mockService.skillsToReturn = [
            makeSkill(id: "s2", skillName: "Python", category: "Languages", orderIndex: 2),
            makeSkill(id: "s0", skillName: "Swift", category: "Languages", orderIndex: 0),
            makeSkill(id: "s1", skillName: "Kotlin", category: "Languages", orderIndex: 1)
        ]
        let viewModel = SkillsViewModel(firebaseService: mockService)
        await viewModel.loadSkills()
        let languageSkills = viewModel.groupedSkills["Languages"] ?? []
        #expect(languageSkills[0].id == "s0")
        #expect(languageSkills[1].id == "s1")
        #expect(languageSkills[2].id == "s2")
    }

    @Test("loadSkills provides sorted category names")
    func loadSkills_providesSortedCategoryNames() async {
        let mockService = MockFirebaseService()
        mockService.skillsToReturn = [
            makeSkill(id: "s1", category: "Frameworks"),
            makeSkill(id: "s2", category: "Languages"),
            makeSkill(id: "s3", category: "Architecture")
        ]
        let viewModel = SkillsViewModel(firebaseService: mockService)
        await viewModel.loadSkills()
        #expect(viewModel.sortedCategories == ["Architecture", "Frameworks", "Languages"])
    }

    @Test("loadSkills sets error state on failure")
    func loadSkills_setsErrorStateOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = SkillsViewModel(firebaseService: mockService)
        await viewModel.loadSkills()
        #expect(viewModel.viewState == .error("No data found in Firestore"))
    }

    @Test("loadSkills keeps groupedSkills empty on failure")
    func loadSkills_keepsGroupedSkillsEmptyOnFailure() async {
        let mockService = MockFirebaseService()
        mockService.errorToThrow = FirebaseServiceError.noDataFound
        let viewModel = SkillsViewModel(firebaseService: mockService)
        await viewModel.loadSkills()
        #expect(viewModel.groupedSkills.isEmpty)
    }

    @Test("loadSkills sets empty state when no skills returned")
    func loadSkills_setsEmptyStateWhenNoData() async {
        let mockService = MockFirebaseService()
        mockService.skillsToReturn = []
        let viewModel = SkillsViewModel(firebaseService: mockService)
        await viewModel.loadSkills()
        #expect(viewModel.viewState == .empty)
    }

    // MARK: - ViewState Equality

    @Test("ViewState idle equals idle")
    func viewState_idleEqualsIdle() {
        #expect(SkillsViewModel.ViewState.idle == .idle)
    }

    @Test("ViewState loaded equals loaded")
    func viewState_loadedEqualsLoaded() {
        #expect(SkillsViewModel.ViewState.loaded == .loaded)
    }

    @Test("ViewState empty equals empty")
    func viewState_emptyEqualsEmpty() {
        #expect(SkillsViewModel.ViewState.empty == .empty)
    }

    @Test("ViewState error equals error with same message")
    func viewState_errorEqualsErrorWithSameMessage() {
        #expect(SkillsViewModel.ViewState.error("oops") == .error("oops"))
    }
}
