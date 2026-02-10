//
//  FirebaseService.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 10/02/2026.
//

import Foundation
import FirebaseFirestore

final class FirebaseService {

    private let database = Firestore.firestore()

    // MARK: - Personal Info

    func fetchPersonalInfo() async throws -> PersonalInfo {
        let snapshot = try await database.collection("personalInfo").getDocuments()

        guard let document = snapshot.documents.first else {
            throw FirebaseServiceError.noDataFound
        }

        let data = try document.data(as: PersonalInfo.self)
        return data
    }

    // MARK: - Work Experience

    func fetchWorkExperiences() async throws -> [WorkExperience] {
        let snapshot = try await database.collection("workExperience")
            .order(by: "startDate", descending: true)
            .getDocuments()

        let experiences = try snapshot.documents.map { document in
            try document.data(as: WorkExperience.self)
        }

        return experiences
    }

    // MARK: - Education

    func fetchEducation() async throws -> [Education] {
        let snapshot = try await database.collection("education")
            .order(by: "startDate", descending: true)
            .getDocuments()

        let education = try snapshot.documents.map { document in
            try document.data(as: Education.self)
        }

        return education
    }

    // MARK: - Skills

    func fetchSkills() async throws -> [Skill] {
        let snapshot = try await database.collection("skills")
            .order(by: "category")
            .getDocuments()

        let skills = try snapshot.documents.map { document in
            try document.data(as: Skill.self)
        }

        return skills
    }

    // MARK: - Languages

    func fetchLanguages() async throws -> [Language] {
        let snapshot = try await database.collection("languages").getDocuments()

        let languages = try snapshot.documents.map { document in
            try document.data(as: Language.self)
        }

        return languages
    }

    // MARK: - Competencies

    func fetchCompetencies() async throws -> [Competency] {
        let snapshot = try await database.collection("competencies").getDocuments()

        let competencies = try snapshot.documents.map { document in
            try document.data(as: Competency.self)
        }

        return competencies
    }

    // MARK: - Interests

    func fetchInterests() async throws -> [Interest] {
        let snapshot = try await database.collection("interests").getDocuments()

        let interests = try snapshot.documents.map { document in
            try document.data(as: Interest.self)
        }

        return interests
    }

    // MARK: - Projects

    func fetchProjects() async throws -> [Project] {
        let snapshot = try await database.collection("projects")
            .order(by: "isFeatured", descending: true)
            .getDocuments()

        let projects = try snapshot.documents.map { document in
            try document.data(as: Project.self)
        }

        return projects
    }

    // MARK: - Social Links

    func fetchSocialLinks() async throws -> SocialLinks {
        let snapshot = try await database.collection("socialLinks").getDocuments()

        guard let document = snapshot.documents.first else {
            throw FirebaseServiceError.noDataFound
        }

        let data = try document.data(as: SocialLinks.self)
        return data
    }
}

// MARK: - Error Types

enum FirebaseServiceError: Error, LocalizedError {
    case noDataFound
    case decodingError

    var errorDescription: String? {
        switch self {
        case .noDataFound:
            return "No data found in Firestore"
        case .decodingError:
            return "Failed to decode Firestore data"
        }
    }
}
