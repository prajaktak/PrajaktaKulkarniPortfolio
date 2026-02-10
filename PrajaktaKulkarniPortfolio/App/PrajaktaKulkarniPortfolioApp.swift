//
//  PrajaktaKulkarniPortfolioApp.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import SwiftUI
import FirebaseCore

@main
struct PrajaktaKulkarniPortfolioApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
