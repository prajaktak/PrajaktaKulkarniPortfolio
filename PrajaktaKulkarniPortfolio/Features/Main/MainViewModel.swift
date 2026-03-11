// MainViewModel.swift
// PrajaktaKulkarniPortfolio
//
// State manager for the main swipeable card navigation.
// Owns the current section index and navigation logic.
// @MainActor ensures all published state updates happen on the main thread.

import SwiftUI
import Observation

/// Manages navigation state for the main portfolio card view.
/// Exposes the section list, current index, and navigation actions.
@Observable
@MainActor
final class MainViewModel {

    // MARK: - State

    /// The ordered list of portfolio sections to display
    let sections: [CardSection] = CardSection.allPortfolioSections

    /// Index of the currently visible card
    var selectedSectionIndex: Int = 0

    // MARK: - Computed Properties

    /// The currently visible CardSection
    var currentSection: CardSection {
        sections[selectedSectionIndex]
    }

    /// True when the first card is visible
    var isFirstSection: Bool {
        selectedSectionIndex == 0
    }

    /// True when the last card is visible
    var isLastSection: Bool {
        selectedSectionIndex == sections.count - 1
    }

    // MARK: - Navigation Actions

    /// Advances to the next section. No-op if already on the last section.
    func navigateToNextSection() {
        guard selectedSectionIndex < sections.count - 1 else { return }
        selectedSectionIndex += 1
    }

    /// Goes back to the previous section. No-op if already on the first section.
    func navigateToPreviousSection() {
        guard selectedSectionIndex > 0 else { return }
        selectedSectionIndex -= 1
    }

    /// Navigates directly to the section at the given index.
    /// Silently ignored if `index` is out of bounds.
    func navigateToSection(at index: Int) {
        guard index >= 0, index < sections.count else { return }
        selectedSectionIndex = index
    }
}
