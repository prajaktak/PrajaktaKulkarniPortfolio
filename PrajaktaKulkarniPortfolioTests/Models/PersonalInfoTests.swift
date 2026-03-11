//
//  PersonalInfoTests.swift
//  PrajaktaKulkarniPortfolioTests
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Testing
@testable import PrajaktaKulkarniPortfolio

struct PersonalInfoTests {

    @Test("PersonalInfo initialises with correct full name")
    func personalInfo_init_setsFullName() {
        let info = PersonalInfo(
            id: "1",
            fullName: "Prajakta Kulkarni",
            email: "test@example.com",
            phoneNumber: "0612345678",
            location: "Hilversum, Netherlands",
            professionalSummary: "Senior iOS Developer"
        )
        #expect(info.fullName == "Prajakta Kulkarni")
    }

    @Test("PersonalInfo initialises with correct email")
    func personalInfo_init_setsEmail() {
        let info = PersonalInfo(
            id: "1",
            fullName: "Prajakta Kulkarni",
            email: "prachee.j@gmail.com",
            phoneNumber: "0612345678",
            location: "Hilversum, Netherlands",
            professionalSummary: "Senior iOS Developer"
        )
        #expect(info.email == "prachee.j@gmail.com")
    }

    @Test("PersonalInfo initialises with correct location")
    func personalInfo_init_setsLocation() {
        let info = PersonalInfo(
            id: "1",
            fullName: "Prajakta Kulkarni",
            email: "test@example.com",
            phoneNumber: "0612345678",
            location: "Hilversum, Netherlands",
            professionalSummary: "Senior iOS Developer"
        )
        #expect(info.location == "Hilversum, Netherlands")
    }

    @Test("PersonalInfo initialises with correct professional summary")
    func personalInfo_init_setsProfessionalSummary() {
        let summary = "Senior iOS Developer with 8+ years experience"
        let info = PersonalInfo(
            id: "1",
            fullName: "Prajakta Kulkarni",
            email: "test@example.com",
            phoneNumber: "0612345678",
            location: "Hilversum, Netherlands",
            professionalSummary: summary
        )
        #expect(info.professionalSummary == summary)
    }
}
