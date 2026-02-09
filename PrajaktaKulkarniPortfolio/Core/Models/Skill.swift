//
//  Skill.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation
import SwiftData

@Model
final class Skill: Codable {
    @Attribute(.unique) var id: String
    var skillName: String
    var category: String
    var proficiencyLevel: String?
    var orderIndex: Int

    init(id: String, skillName: String, category: String, proficiencyLevel: String?, orderIndex: Int) {
        self.id = id
        self.skillName = skillName
        self.category = category
        self.proficiencyLevel = proficiencyLevel
        self.orderIndex = orderIndex
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, skillName, category, proficiencyLevel, orderIndex
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        skillName = try container.decode(String.self, forKey: .skillName)
        category = try container.decode(String.self, forKey: .category)
        proficiencyLevel = try container.decodeIfPresent(String.self, forKey: .proficiencyLevel)
        orderIndex = try container.decode(Int.self, forKey: .orderIndex)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(skillName, forKey: .skillName)
        try container.encode(category, forKey: .category)
        try container.encodeIfPresent(proficiencyLevel, forKey: .proficiencyLevel)
        try container.encode(orderIndex, forKey: .orderIndex)
    }
}
