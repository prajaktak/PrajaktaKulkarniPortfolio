//
//  Project.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation
import SwiftData

@Model
final class Project: Codable {
    @Attribute(.unique) var id: String
    var title: String
    var startDate: Date
    var endDate: Date?
    var projectDescription: String
    var techStack: [String]
    var githubURL: String?
    var screenshotURLs: [String]
    var demoVideoURL: String?
    var isFeatured: Bool
    var orderIndex: Int

    var isOngoing: Bool {
        endDate == nil
    }

    init(id: String, title: String, startDate: Date, endDate: Date?, projectDescription: String, techStack: [String], githubURL: String?, screenshotURLs: [String], demoVideoURL: String?, isFeatured: Bool, orderIndex: Int) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.projectDescription = projectDescription
        self.techStack = techStack
        self.githubURL = githubURL
        self.screenshotURLs = screenshotURLs
        self.demoVideoURL = demoVideoURL
        self.isFeatured = isFeatured
        self.orderIndex = orderIndex
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, title, startDate, endDate, projectDescription, techStack, githubURL, screenshotURLs, demoVideoURL, isFeatured, orderIndex
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decodeIfPresent(Date.self, forKey: .endDate)
        projectDescription = try container.decode(String.self, forKey: .projectDescription)
        techStack = try container.decode([String].self, forKey: .techStack)
        githubURL = try container.decodeIfPresent(String.self, forKey: .githubURL)
        screenshotURLs = try container.decode([String].self, forKey: .screenshotURLs)
        demoVideoURL = try container.decodeIfPresent(String.self, forKey: .demoVideoURL)
        isFeatured = try container.decode(Bool.self, forKey: .isFeatured)
        orderIndex = try container.decode(Int.self, forKey: .orderIndex)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(startDate, forKey: .startDate)
        try container.encodeIfPresent(endDate, forKey: .endDate)
        try container.encode(projectDescription, forKey: .projectDescription)
        try container.encode(techStack, forKey: .techStack)
        try container.encodeIfPresent(githubURL, forKey: .githubURL)
        try container.encode(screenshotURLs, forKey: .screenshotURLs)
        try container.encodeIfPresent(demoVideoURL, forKey: .demoVideoURL)
        try container.encode(isFeatured, forKey: .isFeatured)
        try container.encode(orderIndex, forKey: .orderIndex)
    }
}
