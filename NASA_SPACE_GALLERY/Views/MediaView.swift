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
                NavigationLink(destination: DetailView(url: URL(string: apod.url)!)) {
                    
                    AsyncImage(url: URL(string: apod.url)) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Color.gray.opacity(0.1)
                                ProgressView()
                            }
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width, height: 300) //
                                .clipped()
                        case .failure:
                            ZStack {
                                Color.gray.opacity(0.1)
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: geo.size.width, height: 300)
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
