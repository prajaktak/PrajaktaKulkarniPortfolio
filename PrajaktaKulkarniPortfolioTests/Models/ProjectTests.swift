//
//  ProjectTests.swift
//  PrajaktaKulkarniPortfolioTests
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Testing
import Foundation
@testable import PrajaktaKulkarniPortfolio

struct ProjectTests {

    private func makeProject(endDate: Date? = nil, isFeatured: Bool = false) -> Project {
        Project(
            id: "proj-1",
            title: "Sequence Game",
            startDate: Date(timeIntervalSince1970: 1_753_920_000), // Aug 2025
            endDate: endDate,
            projectDescription: "A memory card game built with SwiftUI",
            techStack: ["SwiftUI", "TDD", "CI/CD", "GitHub Actions"],
            githubURL: "https://github.com/prajakta/sequence",
            screenshotURLs: [],
            demoVideoURL: nil,
            isFeatured: isFeatured,
            orderIndex: 1
        )
    }

    @Test("Project with no end date is ongoing")
    func project_noEndDate_isOngoing() {
        let project = makeProject(endDate: nil)
        #expect(project.isOngoing == true)
    }

    @Test("Project with an end date is not ongoing")
    func project_withEndDate_isNotOngoing() {
        let endDate = Date()
        let project = makeProject(endDate: endDate)
        #expect(project.isOngoing == false)
    }

    @Test("Featured project has isFeatured set to true")
    func project_featured_isFeaturedIsTrue() {
        let project = makeProject(isFeatured: true)
        #expect(project.isFeatured == true)
    }

    @Test("Non-featured project has isFeatured set to false")
    func project_notFeatured_isFeaturedIsFalse() {
        let project = makeProject(isFeatured: false)
        #expect(project.isFeatured == false)
    }

    @Test("Project initialises with correct title")
    func project_init_setsTitle() {
        let project = makeProject()
        #expect(project.title == "Sequence Game")
    }

    @Test("Project initialises with non-empty tech stack")
    func project_init_techStackIsNotEmpty() {
        let project = makeProject()
        #expect(!project.techStack.isEmpty)
    }

    @Test("Project initialises with correct GitHub URL")
    func project_init_setsGithubURL() {
        let project = makeProject()
        #expect(project.githubURL == "https://github.com/prajakta/sequence")
    }
}
