//
//  Project.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation

struct Project: Identifiable, Codable {
    let id: String
    let title: String
    let startDate: Date
    let endDate: Date?
    let projectDescription: String
    let techStack: [String]
    let githubURL: String?
    let screenshotURLs: [String]
    let demoVideoURL: String?
    let isFeatured: Bool
    let orderIndex: Int

    var isOngoing: Bool {
        endDate == nil
    }
}
