// ContactViewModel.swift
// PrajaktaKulkarniPortfolio
//
// Loads social links from Firebase for the Contact card.

import SwiftUI
import Observation

/// State manager for the Contact card.
/// Fetches social links (LinkedIn, GitHub, email) from Firebase.
@Observable
@MainActor
final class ContactViewModel {

    // MARK: - Nested Types

    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
    }

    // MARK: - State

    private(set) var viewState: ViewState = .idle

    /// Social links loaded from Firebase
    private(set) var socialLinks: SocialLinks?

    // MARK: - Dependencies

    private let firebaseService: any FirebaseServiceProtocol

    // MARK: - Init

    init(firebaseService: any FirebaseServiceProtocol = FirebaseService()) {
        self.firebaseService = firebaseService
    }

    // MARK: - Actions

    /// Fetches social links from Firebase.
    func loadContact() async {
        viewState = .loading
        do {
            let links = try await firebaseService.fetchSocialLinks()
            socialLinks = links
            viewState = .loaded
        } catch {
            socialLinks = nil
            viewState = .error(error.localizedDescription)
        }
    }
}
