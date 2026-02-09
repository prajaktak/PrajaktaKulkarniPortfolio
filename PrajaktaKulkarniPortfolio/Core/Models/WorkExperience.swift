//
//  WorkExperience.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation
import SwiftData

@Model
final class WorkExperience: Codable {
    @Attribute(.unique) var id: String
    var companyName: String
    var jobTitle: String
    var startDate: Date
    var endDate: Date?
    var hoursPerWeek: Int
    var jobDescription: String
    var technologiesUsed: [String]
    var orderIndex: Int

    var isCurrentPosition: Bool {
        endDate == nil
    }

    init(id: String, companyName: String, jobTitle: String, startDate: Date, endDate: Date?, hoursPerWeek: Int, jobDescription: String, technologiesUsed: [String], orderIndex: Int) {
        self.id = id
        self.companyName = companyName
        self.jobTitle = jobTitle
        self.startDate = startDate
        self.endDate = endDate
        self.hoursPerWeek = hoursPerWeek
        self.jobDescription = jobDescription
        self.technologiesUsed = technologiesUsed
        self.orderIndex = orderIndex
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, companyName, jobTitle, startDate, endDate, hoursPerWeek, jobDescription, technologiesUsed, orderIndex
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        companyName = try container.decode(String.self, forKey: .companyName)
        jobTitle = try container.decode(String.self, forKey: .jobTitle)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decodeIfPresent(Date.self, forKey: .endDate)
        hoursPerWeek = try container.decode(Int.self, forKey: .hoursPerWeek)
        jobDescription = try container.decode(String.self, forKey: .jobDescription)
        technologiesUsed = try container.decode([String].self, forKey: .technologiesUsed)
        orderIndex = try container.decode(Int.self, forKey: .orderIndex)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(companyName, forKey: .companyName)
        try container.encode(jobTitle, forKey: .jobTitle)
        try container.encode(startDate, forKey: .startDate)
        try container.encodeIfPresent(endDate, forKey: .endDate)
        try container.encode(hoursPerWeek, forKey: .hoursPerWeek)
        try container.encode(jobDescription, forKey: .jobDescription)
        try container.encode(technologiesUsed, forKey: .technologiesUsed)
        try container.encode(orderIndex, forKey: .orderIndex)
    }
}
