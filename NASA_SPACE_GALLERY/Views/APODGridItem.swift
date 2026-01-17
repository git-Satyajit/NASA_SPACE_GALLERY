//
//  APODGridItem.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 17/01/26.
//

import SwiftUI

struct APODGridItem: View {
    let apod: APODModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 1. Image
            ZStack(alignment: .topTrailing) {
                CachedImageView(url: URL(string: apod.url)!)
                    .scaledToFill()                 // Zoom to fill square
                    .frame(width: (UIScreen.main.bounds.width / 2) - 24)
                    .frame(height: 160)             // Fixed height
                    .clipped()                      // Cut off edges
                
                // Heart Icon
                Image(systemName: "heart")
                    .foregroundColor(.red)
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
                    .padding(4)
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
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
