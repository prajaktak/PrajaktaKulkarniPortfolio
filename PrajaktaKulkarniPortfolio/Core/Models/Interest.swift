//
//  Interest.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation
import SwiftData

@Model
final class Interest: Codable {
    @Attribute(.unique) var id: String
    var interestTitle: String
    var interestDescription: String
    var orderIndex: Int

    init(id: String, interestTitle: String, interestDescription: String, orderIndex: Int) {
        self.id = id
        self.interestTitle = interestTitle
        self.interestDescription = interestDescription
        self.orderIndex = orderIndex
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, interestTitle, interestDescription, orderIndex
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        interestTitle = try container.decode(String.self, forKey: .interestTitle)
        interestDescription = try container.decode(String.self, forKey: .interestDescription)
        orderIndex = try container.decode(Int.self, forKey: .orderIndex)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(interestTitle, forKey: .interestTitle)
        try container.encode(interestDescription, forKey: .interestDescription)
        try container.encode(orderIndex, forKey: .orderIndex)
    }
}
