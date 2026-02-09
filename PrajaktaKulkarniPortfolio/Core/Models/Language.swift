//
//  Language.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation
import SwiftData

@Model
final class Language: Codable {
    @Attribute(.unique) var id: String
    var languageName: String
    var speakingProficiency: String
    var writingProficiency: String

    init(id: String, languageName: String, speakingProficiency: String, writingProficiency: String) {
        self.id = id
        self.languageName = languageName
        self.speakingProficiency = speakingProficiency
        self.writingProficiency = writingProficiency
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, languageName, speakingProficiency, writingProficiency
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        languageName = try container.decode(String.self, forKey: .languageName)
        speakingProficiency = try container.decode(String.self, forKey: .speakingProficiency)
        writingProficiency = try container.decode(String.self, forKey: .writingProficiency)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(languageName, forKey: .languageName)
        try container.encode(speakingProficiency, forKey: .speakingProficiency)
        try container.encode(writingProficiency, forKey: .writingProficiency)
    }
}
