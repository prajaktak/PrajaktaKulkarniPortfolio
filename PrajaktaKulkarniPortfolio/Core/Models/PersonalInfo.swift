//
//  PersonalInfo.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation
import SwiftData

@Model
final class PersonalInfo: Codable {
    @Attribute(.unique) var id: String
    var fullName: String
    var email: String
    var phoneNumber: String
    var location: String
    var professionalSummary: String

    init(id: String, fullName: String, email: String, phoneNumber: String, location: String, professionalSummary: String) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.location = location
        self.professionalSummary = professionalSummary
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, fullName, email, phoneNumber, location, professionalSummary
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        fullName = try container.decode(String.self, forKey: .fullName)
        email = try container.decode(String.self, forKey: .email)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        location = try container.decode(String.self, forKey: .location)
        professionalSummary = try container.decode(String.self, forKey: .professionalSummary)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(email, forKey: .email)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(location, forKey: .location)
        try container.encode(professionalSummary, forKey: .professionalSummary)
    }
}
