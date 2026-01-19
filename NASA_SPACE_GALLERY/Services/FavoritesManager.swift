//
//  FavoritesManager.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 19/01/26.
//
import Foundation
import CoreData
import SwiftUI
import Combine

class FavoritesManager: ObservableObject {
    // Singleton: One manager for the whole app
    static let shared = FavoritesManager()
    
    // The Database Context (Your "Notebook")
    private let context = PersistenceController.shared.container.viewContext
    
    // Published list so UI updates automatically
    @Published var savedAPODs: [FavoriteAPOD] = []
    
    private init() {
        fetchAllFavorites()
    }
    
    // MARK: - Save (Toggle Logic)
    func toggleFavorite(apod: APODModel) {
        if let existingEntity = getEntity(for: apod) {
            // If it exists, DELETE it (Un-like)
            delete(entity: existingEntity)
        } else {
            // If it doesn't exist, SAVE it (Like)
            save(apod: apod)
        }
    }
    
    // Check if an APOD is already liked (for the Heart Icon color)
    func isFavorite(_ apod: APODModel) -> Bool {
        return getEntity(for: apod) != nil
    }
    
    // MARK: - Private Helpers
    
    private func save(apod: APODModel) {
        let newFavorite = FavoriteAPOD(context: context)
        newFavorite.id = apod.date // Using Date as the unique ID
        newFavorite.date = apod.date
        newFavorite.title = apod.title
        newFavorite.explanation = apod.explanation
        newFavorite.url = apod.url
        newFavorite.hdurl = apod.hdurl
        newFavorite.mediaType = apod.mediaType
        newFavorite.copyright = apod.copyright
        newFavorite.timestamp = Date() // Saved time
        
        saveContext()
    }
    
    private func delete(entity: FavoriteAPOD) {
        context.delete(entity)
        saveContext()
    }
    
    // Fetch all favorites from Disk to RAM
    func fetchAllFavorites() {
        let request: NSFetchRequest<FavoriteAPOD> = FavoriteAPOD.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)] // Newest first
        
        do {
            savedAPODs = try context.fetch(request)
        } catch {
            print("❌ Error fetching favorites: \(error)")
        }
    }
    
    // Helper to find a specific item in the database
    private func getEntity(for apod: APODModel) -> FavoriteAPOD? {
        let request: NSFetchRequest<FavoriteAPOD> = FavoriteAPOD.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", apod.date)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("❌ Error checking favorite: \(error)")
            return nil
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
            fetchAllFavorites() // Refresh the list after saving
            print("✅ Database Saved Successfully")
        } catch {
            print("❌ Error saving context: \(error)")
        }
    }
}

extension FavoriteAPOD {
    // Converts Core Data Object -> App Model
    func toAPODModel() -> APODModel {
        return APODModel(
            date: self.date ?? "",
            title: self.title ?? "Unknown",
            explanation: self.explanation ?? "",
            url: self.url ?? "",
            mediaType: self.mediaType ?? "image",
            hdurl: self.hdurl,
            copyright: self.copyright,
            serviceVersion: nil // Not needed for display
        )
    }
}
