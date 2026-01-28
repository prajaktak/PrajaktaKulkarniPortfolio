//
//  PersonalInfo.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation

struct PersonalInfo: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    let phoneNumber: String
    let location: String
    let professionalSummary: String
}
