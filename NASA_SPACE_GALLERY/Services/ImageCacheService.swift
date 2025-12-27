//
//  ImageCacheService.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 27/12/25.
//

import Foundation
import SwiftUI

class ImageCacheService {
    // 1. Singleton Instance (Global Access)
    static let shared = ImageCacheService()
    
    // 2. Memory Cache (RAM) - Fast access, wipes on close
    private let memoryCache = NSCache<NSString, UIImage>()
    
    // 3. Disk Cache (Storage) - Persists offline
    private let fileManager = FileManager.default
    private let folderName = "NASA_Image_Cache"
    
    private init() {
        createCacheFolder()
    }
    
    // MARK: - Folder Setup
    private func createCacheFolder() {
        guard let url = getCacheFolderURL() else { return }
        if !fileManager.fileExists(atPath: url.path) {
            try? fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }
    
    private func getCacheFolderURL() -> URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?
            .appendingPathComponent(folderName)
    }
    
    private func getImageName(from url: URL) -> String {
        // Create a unique filename using Base64 so special chars don't break it
        return url.absoluteString.data(using: .utf8)?.base64EncodedString() ?? "unknown"
    }
    
    // MARK: - Main Functions
    
    func getImage(for url: URL) -> UIImage? {
        let key = NSString(string: url.absoluteString)
        
        // 1. Check RAM (Fastest)
        if let cachedImage = memoryCache.object(forKey: key) {
            print("✅ [MEMORY CACHE] Hit: \(url.lastPathComponent)")
            return cachedImage
        }
        
        // 2. Check Disk (Slower, but persistent)
        if let folderURL = getCacheFolderURL() {
            let fileURL = folderURL.appendingPathComponent(getImageName(from: url))
            if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
                // Determine if we found it on disk, save back to RAM for next time
                print("💾 [DISK CACHE] Hit: \(url.lastPathComponent)")
                memoryCache.setObject(image, forKey: key)
                return image
            }
        }
        print("☁️ [NETWORK] Downloading: \(url.lastPathComponent)")
        return nil // Not in cache
    }
    
    func saveImage(_ image: UIImage, for url: URL) {
        let key = NSString(string: url.absoluteString)
        
        // 1. Save to RAM
        memoryCache.setObject(image, forKey: key)
        
        // 2. Save to Disk
        guard let data = image.jpegData(compressionQuality: 0.8),
              let folderURL = getCacheFolderURL() else { return }
        
        let fileURL = folderURL.appendingPathComponent(getImageName(from: url))
        try? data.write(to: fileURL)
    }
}
