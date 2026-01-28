//
//  Education.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation

struct Education: Identifiable, Codable {
    let id: String
    let degreeName: String
    let fieldOfStudy: String
    let institutionName: String
    let startDate: Date
    let endDate: Date
    let subjectsStudied: String
    let hasDiploma: Bool
    let orderIndex: Int
}
