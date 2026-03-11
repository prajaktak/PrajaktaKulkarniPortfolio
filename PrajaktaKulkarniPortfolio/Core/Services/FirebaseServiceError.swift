//
//  FirebaseServiceError.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import Foundation

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
