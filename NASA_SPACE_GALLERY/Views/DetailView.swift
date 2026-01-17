//
//  DetailView.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 25/12/25.
//

import SwiftUI

struct DetailView: View {
    let apod: APODModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Full Image (Aspect Fit)
                CachedImageView(url: URL(string: apod.url)!)
                    .scaledToFit()
                    .cornerRadius(0)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(apod.title).font(.title).bold()
                    Text(apod.date).foregroundColor(.secondary)
                    Divider()
                    Text(apod.explanation).lineSpacing(4)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
