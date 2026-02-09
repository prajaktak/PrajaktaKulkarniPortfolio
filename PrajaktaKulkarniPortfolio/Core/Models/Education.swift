//
//  Education.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation
import SwiftData

@Model
final class Education: Codable {
    @Attribute(.unique) var id: String
    var degreeName: String
    var fieldOfStudy: String
    var institutionName: String
    var startDate: Date
    var endDate: Date
    var subjectsStudied: String
    var hasDiploma: Bool
    var orderIndex: Int

    init(id: String, degreeName: String, fieldOfStudy: String, institutionName: String, startDate: Date, endDate: Date, subjectsStudied: String, hasDiploma: Bool, orderIndex: Int) {
        self.id = id
        self.degreeName = degreeName
        self.fieldOfStudy = fieldOfStudy
        self.institutionName = institutionName
        self.startDate = startDate
        self.endDate = endDate
        self.subjectsStudied = subjectsStudied
        self.hasDiploma = hasDiploma
        self.orderIndex = orderIndex
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, degreeName, fieldOfStudy, institutionName, startDate, endDate, subjectsStudied, hasDiploma, orderIndex
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        degreeName = try container.decode(String.self, forKey: .degreeName)
        fieldOfStudy = try container.decode(String.self, forKey: .fieldOfStudy)
        institutionName = try container.decode(String.self, forKey: .institutionName)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        subjectsStudied = try container.decode(String.self, forKey: .subjectsStudied)
        hasDiploma = try container.decode(Bool.self, forKey: .hasDiploma)
        orderIndex = try container.decode(Int.self, forKey: .orderIndex)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(degreeName, forKey: .degreeName)
        try container.encode(fieldOfStudy, forKey: .fieldOfStudy)
        try container.encode(institutionName, forKey: .institutionName)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(subjectsStudied, forKey: .subjectsStudied)
        try container.encode(hasDiploma, forKey: .hasDiploma)
        try container.encode(orderIndex, forKey: .orderIndex)
    }
}
