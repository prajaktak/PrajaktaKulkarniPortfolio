//
//  WorkExperience.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation

struct WorkExperience: Identifiable, Codable {
    let id: String
    let companyName: String
    let jobTitle: String
    let startDate: Date
    let endDate: Date?
    let hoursPerWeek: Int
    let jobDescription: String
    let technologiesUsed: [String]
    let orderIndex: Int

    var isCurrentPosition: Bool {
        endDate == nil
    }
}
