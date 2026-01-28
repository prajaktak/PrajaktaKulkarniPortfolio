//
//  Skill.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation

struct Skill: Identifiable, Codable {
    let id: String
    let skillName: String
    let category: String
    let proficiencyLevel: String?
    let orderIndex: Int
}
