//
//  Competency.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation

struct Competency: Identifiable, Codable {
    let id: String
    let competencyTitle: String
    let competencyDescription: String
    let orderIndex: Int
}
