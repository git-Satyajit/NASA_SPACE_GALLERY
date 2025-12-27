//
//  ImageLoader.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 27/12/25.
//

import Foundation
import SwiftUI
import Combine

// 1. The Loader Object to handle state updates
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        loadImage()
    }
    
    func loadImage() {
        // A. Check Cache First
        if let cached = ImageCacheService.shared.getImage(for: url) {
            self.image = cached
            return
        }
        
        // B. Download if not in Cache
        isLoading = true
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let downloadedImage = UIImage(data: data) else { return }
                
                await MainActor.run {
                    // Save to Cache & Update UI
                    ImageCacheService.shared.saveImage(downloadedImage, for: url)
                    self.image = downloadedImage
                    self.isLoading = false
                }
            } catch {
                print("Error downloading image: \(error)")
                await MainActor.run { self.isLoading = false }
            }
        }
    }
}
