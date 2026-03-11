//
//  SkillTests.swift
//  PrajaktaKulkarniPortfolioTests
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Testing
@testable import PrajaktaKulkarniPortfolio

struct SkillTests {

    @Test("Skill initialises with correct skill name")
    func skill_init_setsSkillName() {
        let skill = Skill(
            id: "skill-1",
            skillName: "Swift",
            category: "Programming Languages",
            proficiencyLevel: "Expert",
            orderIndex: 1
        )
        #expect(skill.skillName == "Swift")
    }

    @Test("Skill initialises with correct category")
    func skill_init_setsCategory() {
        let skill = Skill(
            id: "skill-1",
            skillName: "Swift",
            category: "Programming Languages",
            proficiencyLevel: "Expert",
            orderIndex: 1
        )
        #expect(skill.category == "Programming Languages")
    }

    @Test("Skill initialises with nil proficiency level when not provided")
    func skill_init_nilProficiencyLevel_isNil() {
        let skill = Skill(
            id: "skill-2",
            skillName: "Xcode",
            category: "Tools",
            proficiencyLevel: nil,
            orderIndex: 2
        )
        #expect(skill.proficiencyLevel == nil)
    }

    @Test("Skill initialises with correct proficiency level when provided")
    func skill_init_withProficiencyLevel_setsValue() {
        let skill = Skill(
            id: "skill-1",
            skillName: "Swift",
            category: "Programming Languages",
            proficiencyLevel: "Expert",
            orderIndex: 1
        )
        #expect(skill.proficiencyLevel == "Expert")
    }
}
