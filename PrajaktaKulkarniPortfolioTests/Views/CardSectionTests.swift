// CardSectionTests.swift
// PrajaktaKulkarniPortfolioTests
//
// Tests for CardSection model — the data that describes each portfolio card.
// Tests verify all CardSection properties are correctly initialised.

import Testing
@testable import PrajaktaKulkarniPortfolio

@Suite("CardSection Tests")
struct CardSectionTests {

    @Test("init sets identifier correctly")
    func init_setsIdentifier() {
        let section = CardSection(
            identifier: "welcome",
            title: "Welcome",
            iconName: "hand.wave.fill"
        )
        #expect(section.identifier == "welcome")
    }

    @Test("init sets title correctly")
    func init_setsTitle() {
        let section = CardSection(
            identifier: "experience",
            title: "Work Experience",
            iconName: "briefcase.fill"
        )
        #expect(section.title == "Work Experience")
    }

    @Test("init sets iconName correctly")
    func init_setsIconName() {
        let section = CardSection(
            identifier: "skills",
            title: "Skills",
            iconName: "star.fill"
        )
        #expect(section.iconName == "star.fill")
    }

    @Test("two sections with same identifier are equal")
    func equality_sameSectionsAreEqual() {
        let sectionOne = CardSection(identifier: "welcome", title: "Welcome", iconName: "hand.wave.fill")
        let sectionTwo = CardSection(identifier: "welcome", title: "Welcome", iconName: "hand.wave.fill")
        #expect(sectionOne == sectionTwo)
    }

    @Test("two sections with different identifiers are not equal")
    func equality_differentIdentifiersAreNotEqual() {
        let sectionOne = CardSection(identifier: "welcome", title: "Welcome", iconName: "hand.wave.fill")
        let sectionTwo = CardSection(identifier: "skills", title: "Skills", iconName: "star.fill")
        #expect(sectionOne != sectionTwo)
    }

    @Test("all default portfolio sections have unique identifiers")
    func defaultSections_haveUniqueIdentifiers() {
        let sections = CardSection.allPortfolioSections
        let identifiers = sections.map { $0.identifier }
        let uniqueIdentifiers = Set(identifiers)
        #expect(identifiers.count == uniqueIdentifiers.count)
    }

    @Test("default portfolio sections are non-empty")
    func defaultSections_areNonEmpty() {
        #expect(CardSection.allPortfolioSections.isEmpty == false)
    }

    @Test("default portfolio sections include welcome section")
    func defaultSections_includeWelcome() {
        let hasWelcome = CardSection.allPortfolioSections.contains { $0.identifier == "welcome" }
        #expect(hasWelcome)
    }

    @Test("default portfolio sections include experience section")
    func defaultSections_includeExperience() {
        let hasExperience = CardSection.allPortfolioSections.contains { $0.identifier == "experience" }
        #expect(hasExperience)
    }

    @Test("default portfolio sections include skills section")
    func defaultSections_includeSkills() {
        let hasSkills = CardSection.allPortfolioSections.contains { $0.identifier == "skills" }
        #expect(hasSkills)
    }

    @Test("default portfolio sections include education section")
    func defaultSections_includeEducation() {
        let hasEducation = CardSection.allPortfolioSections.contains { $0.identifier == "education" }
        #expect(hasEducation)
    }

    @Test("default portfolio sections include projects section")
    func defaultSections_includeProjects() {
        let hasProjects = CardSection.allPortfolioSections.contains { $0.identifier == "projects" }
        #expect(hasProjects)
    }

    @Test("default portfolio sections include contact section")
    func defaultSections_includeContact() {
        let hasContact = CardSection.allPortfolioSections.contains { $0.identifier == "contact" }
        #expect(hasContact)
    }
}
