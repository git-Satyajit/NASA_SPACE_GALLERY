//
//  CachedImageView.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 27/12/25.
//

import SwiftUI
import Combine

// 2. The SwiftUI View
struct CachedImageView: View {
    @StateObject private var loader: ImageLoader
    
    init(url: URL) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        ZStack {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else if loader.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            }
        }
    }
}
