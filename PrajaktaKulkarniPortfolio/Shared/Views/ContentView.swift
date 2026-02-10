//
//  ContentView.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//

import SwiftUI

struct ContentView: View {

    @State private var isPopulating = false
    @State private var showCompletionAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "flame.fill")
                .imageScale(.large)
                .font(.system(size: 60))
                .foregroundStyle(.orange)

            Text("Firestore Data Populator")
                .font(.title)
                .fontWeight(.bold)

            Text("Click the button below to populate your Firestore database with CV data")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            if isPopulating {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
                Text("Populating Firestore...")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Button {
                    populateFirestore()
                } label: {
                    Label("Populate Firestore", systemImage: "cloud.fill")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .alert("Success!", isPresented: $showCompletionAlert) {
            Button("OK") { }
        } message: {
            Text("All CV data has been successfully populated in Firestore! Check the Xcode console for details.")
        }
    }

    private func populateFirestore() {
        isPopulating = true
        print("🔥 Button tapped - starting population...")

        Task {
            do {
                print("✅ Task started")
                let populator = FirestoreDataPopulator()
                await populator.populateAllData()

                await MainActor.run {
                    isPopulating = false
                    showCompletionAlert = true
                    print("✅ Completed and showing alert")
                }
            } catch {
                print("❌ Error in Task: \(error)")
                await MainActor.run {
                    isPopulating = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
