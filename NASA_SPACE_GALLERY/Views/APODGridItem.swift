//
//  APODGridItem.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 17/01/26.
//

import SwiftUI

struct APODGridItem: View {
    let apod: APODModel
    @ObservedObject var favoritesManager = FavoritesManager.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 1. Image
            ZStack(alignment: .topTrailing) {
                if let validURL = URL(string: apod.url) {
                    CachedImageView(url: validURL)
                        .scaledToFill()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 24)
                        .frame(height: 160)
                        .clipped()
                } else {
                    // Fallback if URL is bad (e.g. empty string from Core Data)
                    ZStack {
                        Color.gray.opacity(0.3)
                        Image(systemName: "photo.slash")
                            .foregroundColor(.gray)
                    }
                    .frame(width: (UIScreen.main.bounds.width / 2) - 24, height: 160)
                }
                // 2. THE HEART BUTTON
                Button(action: {
                    // Trigger the Save/Delete Logic
                    favoritesManager.toggleFavorite(apod: apod)
                    
                    // Optional: Haptic Feedback for a nice "click" feel
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                }) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 32, height: 32)
                        
                        // 3. Dynamic Icon Logic
                        Image(systemName: favoritesManager.isFavorite(apod) ? "heart.fill" : "heart")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(favoritesManager.isFavorite(apod) ? .red : .gray)
                            .animation(.spring(), value: favoritesManager.isFavorite(apod)) // Bouncy animation
                    }
                }
                .padding(8)
            }
            
            // 2. Text
            VStack(alignment: .leading, spacing: 4) {
                Text(apod.title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                    .frame(height: 35, alignment: .topLeading)
                
                Text(apod.date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(8)
            .background(Color(uiColor: .systemBackground))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.clear, lineWidth: 1)
        )
        .cornerRadius(12)
        .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
