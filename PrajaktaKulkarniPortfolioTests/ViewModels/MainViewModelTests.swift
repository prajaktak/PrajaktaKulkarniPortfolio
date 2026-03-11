// MainViewModelTests.swift
// PrajaktaKulkarniPortfolioTests
//
// Tests for MainViewModel — the state manager for the swipeable card navigation.
// One behavior per test, following TDD approach.

import Testing
@testable import PrajaktaKulkarniPortfolio

@Suite("MainViewModel Tests")
@MainActor
struct MainViewModelTests {

    @Test("initialises with first section selected")
    func init_selectsFirstSection() {
        let viewModel = MainViewModel()
        #expect(viewModel.selectedSectionIndex == 0)
    }

    @Test("initialises with all portfolio sections loaded")
    func init_loadsAllPortfolioSections() {
        let viewModel = MainViewModel()
        #expect(viewModel.sections.count == CardSection.allPortfolioSections.count)
    }

    @Test("sections match the canonical portfolio section list")
    func sections_matchPortfolioSections() {
        let viewModel = MainViewModel()
        #expect(viewModel.sections == CardSection.allPortfolioSections)
    }

    @Test("navigateToNextSection increments index by one")
    func navigateToNextSection_incrementsIndex() {
        let viewModel = MainViewModel()
        viewModel.navigateToNextSection()
        #expect(viewModel.selectedSectionIndex == 1)
    }

    @Test("navigateToNextSection does not exceed last section index")
    func navigateToNextSection_doesNotExceedLastIndex() {
        let viewModel = MainViewModel()
        let lastIndex = viewModel.sections.count - 1
        viewModel.selectedSectionIndex = lastIndex
        viewModel.navigateToNextSection()
        #expect(viewModel.selectedSectionIndex == lastIndex)
    }

    @Test("navigateToPreviousSection decrements index by one")
    func navigateToPreviousSection_decrementsIndex() {
        let viewModel = MainViewModel()
        viewModel.selectedSectionIndex = 2
        viewModel.navigateToPreviousSection()
        #expect(viewModel.selectedSectionIndex == 1)
    }

    @Test("navigateToPreviousSection does not go below zero")
    func navigateToPreviousSection_doesNotGoBelowZero() {
        let viewModel = MainViewModel()
        viewModel.selectedSectionIndex = 0
        viewModel.navigateToPreviousSection()
        #expect(viewModel.selectedSectionIndex == 0)
    }

    @Test("navigateToSection sets correct index")
    func navigateToSection_setsCorrectIndex() {
        let viewModel = MainViewModel()
        viewModel.navigateToSection(at: 3)
        #expect(viewModel.selectedSectionIndex == 3)
    }

    @Test("navigateToSection ignores out-of-bounds index")
    func navigateToSection_ignoresOutOfBoundsIndex() {
        let viewModel = MainViewModel()
        viewModel.navigateToSection(at: 100)
        #expect(viewModel.selectedSectionIndex == 0)
    }

    @Test("isFirstSection returns true when on first section")
    func isFirstSection_returnsTrueForIndexZero() {
        let viewModel = MainViewModel()
        #expect(viewModel.isFirstSection == true)
    }

    @Test("isFirstSection returns false when not on first section")
    func isFirstSection_returnsFalseWhenNotFirst() {
        let viewModel = MainViewModel()
        viewModel.selectedSectionIndex = 1
        #expect(viewModel.isFirstSection == false)
    }

    @Test("isLastSection returns true when on last section")
    func isLastSection_returnsTrueForLastIndex() {
        let viewModel = MainViewModel()
        viewModel.selectedSectionIndex = viewModel.sections.count - 1
        #expect(viewModel.isLastSection == true)
    }

    @Test("isLastSection returns false when not on last section")
    func isLastSection_returnsFalseWhenNotLast() {
        let viewModel = MainViewModel()
        #expect(viewModel.isLastSection == false)
    }

    @Test("currentSection returns section at selected index")
    func currentSection_returnsSectionAtSelectedIndex() {
        let viewModel = MainViewModel()
        viewModel.selectedSectionIndex = 2
        #expect(viewModel.currentSection == viewModel.sections[2])
    }
}
