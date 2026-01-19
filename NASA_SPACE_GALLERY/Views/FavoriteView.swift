//
//  FavoriteView.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 19/01/26.
//

import SwiftUI

struct FavoriteView: View {
    // 1. Listen to the Database Manager
    @ObservedObject var manager = FavoritesManager.shared
    
    // Grid Setup (Same as HomeView)
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Color
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                if manager.savedAPODs.isEmpty {
                    // 2. EMPTY STATE
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(Color.secondary)
                        Text("No Favorites Yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Go to the Home tab and tap the heart icon to save photos here.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    // 3. GRID STATE
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(manager.savedAPODs, id: \.date) { entity in
                                // Convert Database Entity -> UI Model
                                let model = entity.toAPODModel()
                                
                                NavigationLink(destination: DetailView(apod: model)) {
                                    APODGridItem(apod: model)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorites ❤️")
            .onAppear {
                // Refresh list every time you open this tab
                manager.fetchAllFavorites()
            }
        }
    }
}
#Preview{
    FavoriteView()
}
