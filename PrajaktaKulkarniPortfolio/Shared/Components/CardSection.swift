// CardSection.swift
// PrajaktaKulkarniPortfolio
//
// Describes a single portfolio card/page shown in the main swipeable navigation.
// Each CardSection maps to one full-screen card in the TabView.

import Foundation

/// A value type that describes a single section/page in the portfolio.
/// Used as the data source for the swipeable card navigation.
struct CardSection: Equatable, Identifiable, Sendable {

    /// Stable unique identifier for this section (e.g. "welcome", "experience")
    let identifier: String

    /// Display title shown in the card header
    let title: String

    /// SF Symbol name for the section icon
    let iconName: String

    /// Conforms to `Identifiable` using the string identifier
    var id: String { identifier }

    // MARK: - Default Portfolio Sections

    /// The ordered list of all portfolio sections shown in the main navigation.
    static let allPortfolioSections: [CardSection] = [
        CardSection(identifier: "welcome", title: "About", iconName: "person.fill"),
        CardSection(identifier: "experience", title: "Experience", iconName: "briefcase.fill"),
        CardSection(identifier: "skills", title: "Skills", iconName: "star.fill"),
        CardSection(identifier: "education", title: "Education", iconName: "graduationcap.fill"),
        CardSection(identifier: "competencies", title: "Competencies", iconName: "brain.head.profile"),
        CardSection(identifier: "interests", title: "Interests", iconName: "heart.fill"),
        CardSection(identifier: "projects", title: "Projects", iconName: "folder.fill"),
        CardSection(identifier: "contact", title: "Contact", iconName: "envelope.fill")
    ]
}
