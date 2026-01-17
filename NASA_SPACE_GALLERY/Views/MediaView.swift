//
//  MediaView.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 25/12/25.
//

import SwiftUI

struct MediaView: View {
    let apod: APODModel
    
    var body: some View {
        GeometryReader { geo in
            if apod.mediaType == "image" {
                NavigationLink(destination: DetailView(apod: apod)) {
                    
                    // 2. NEW Cached Image View (Replaces AsyncImage)
                    CachedImageView(url: URL(string: apod.url)!)
                        .scaledToFill()
                        .frame(width: geo.size.width, height: 300)
                        .clipped() // Prevents image from spilling out of the row
                }
                
            } else {
                Link(destination: URL(string: apod.url)!) {
                    ZStack {
                        Color.black
                        VStack {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                            Text("Watch Video")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    }
                    .frame(width: geo.size.width, height: 300)
                }
            }
        }
        .frame(height: 300)
    }
}
