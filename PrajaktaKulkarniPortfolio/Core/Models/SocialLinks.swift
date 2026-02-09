//
//  SocialLinks.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation
import SwiftData

@Model
final class SocialLinks: Codable {
    @Attribute(.unique) var id: String
    var linkedInURL: String
    var githubURL: String
    var emailAddress: String

    init(id: String, linkedInURL: String, githubURL: String, emailAddress: String) {
        self.id = id
        self.linkedInURL = linkedInURL
        self.githubURL = githubURL
        self.emailAddress = emailAddress
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, linkedInURL, githubURL, emailAddress
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        linkedInURL = try container.decode(String.self, forKey: .linkedInURL)
        githubURL = try container.decode(String.self, forKey: .githubURL)
        emailAddress = try container.decode(String.self, forKey: .emailAddress)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(linkedInURL, forKey: .linkedInURL)
        try container.encode(githubURL, forKey: .githubURL)
        try container.encode(emailAddress, forKey: .emailAddress)
    }
}
