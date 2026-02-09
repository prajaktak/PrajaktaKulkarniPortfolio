//
//  Competency.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation
import SwiftData

@Model
final class Competency: Codable {
    @Attribute(.unique) var id: String
    var competencyTitle: String
    var competencyDescription: String
    var orderIndex: Int

    init(id: String, competencyTitle: String, competencyDescription: String, orderIndex: Int) {
        self.id = id
        self.competencyTitle = competencyTitle
        self.competencyDescription = competencyDescription
        self.orderIndex = orderIndex
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, competencyTitle, competencyDescription, orderIndex
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        competencyTitle = try container.decode(String.self, forKey: .competencyTitle)
        competencyDescription = try container.decode(String.self, forKey: .competencyDescription)
        orderIndex = try container.decode(Int.self, forKey: .orderIndex)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(competencyTitle, forKey: .competencyTitle)
        try container.encode(competencyDescription, forKey: .competencyDescription)
        try container.encode(orderIndex, forKey: .orderIndex)
    }
}
