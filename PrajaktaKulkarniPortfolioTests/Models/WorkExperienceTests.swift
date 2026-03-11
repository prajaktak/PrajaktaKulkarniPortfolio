//
//  WorkExperienceTests.swift
//  PrajaktaKulkarniPortfolioTests
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Testing
import Foundation
@testable import PrajaktaKulkarniPortfolio

struct WorkExperienceTests {

    private func makeWorkExperience(endDate: Date? = nil) -> WorkExperience {
        WorkExperience(
            id: "exp-1",
            companyName: "Mirum Agency",
            jobTitle: "Lead Mobile App Developer",
            startDate: Date(timeIntervalSince1970: 1_427_846_400), // Apr 2015
            endDate: endDate,
            hoursPerWeek: 40,
            jobDescription: "Led mobile app development team",
            technologiesUsed: ["Swift", "UIKit", "Firebase"],
            orderIndex: 1
        )
    }

    @Test("WorkExperience with no end date is a current position")
    func workExperience_noEndDate_isCurrentPosition() {
        let experience = makeWorkExperience(endDate: nil)
        #expect(experience.isCurrentPosition == true)
    }

    @Test("WorkExperience with an end date is not a current position")
    func workExperience_withEndDate_isNotCurrentPosition() {
        let endDate = Date(timeIntervalSince1970: 1_519_862_400) // Feb 2018
        let experience = makeWorkExperience(endDate: endDate)
        #expect(experience.isCurrentPosition == false)
    }

    @Test("WorkExperience initialises with correct company name")
    func workExperience_init_setsCompanyName() {
        let experience = makeWorkExperience()
        #expect(experience.companyName == "Mirum Agency")
    }

    @Test("WorkExperience initialises with correct technologies list")
    func workExperience_init_setsTechnologiesUsed() {
        let experience = makeWorkExperience()
        #expect(experience.technologiesUsed.contains("Swift"))
        #expect(experience.technologiesUsed.contains("UIKit"))
    }

    @Test("WorkExperience initialises with non-empty technologies list")
    func workExperience_init_technologiesUsedIsNotEmpty() {
        let experience = makeWorkExperience()
        #expect(!experience.technologiesUsed.isEmpty)
    }
}
