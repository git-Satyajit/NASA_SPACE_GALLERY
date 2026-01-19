//
//  HomeViewModel.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 25/12/25.
//

import Foundation
import Combine

enum ViewState {
    case idle
    case loading
    case success([APODModel])
    case error(String)
}

@MainActor
class HomeViewModel: ObservableObject {
    @Published var state: ViewState = .idle
    @Published var selectedDate: Date = Date()
    private var ignoreDateChange = false
    private let service: APIServiceProtocol
    
    init(service: APIServiceProtocol = APIService()) {
        self.service = service
    }
    
    // MARK: - 1. Load the Grid (Reset)
    func loadRecentPhotos() {
        print("🔄 User tapped Refresh: Loading Grid...")
        
        // 1. Raise the flag! Tell loadDate() to ignore the next update
        ignoreDateChange = true
        
        // 2. Reset the Date Picker UI to Today
        self.selectedDate = Date()
        
        // 3. Fetch the Grid (FORCE LOAD - Removed the "return" check)
        self.state = .loading
        Task {
            do {
                let photos = try await service.fetchRecentPhotos(days: 7)
                self.state = .success(photos)
            } catch {
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    // MARK: - 2. Load Single Date
    func loadDate(_ date: Date) {
        // Check the flag
        if ignoreDateChange {
            print("🛑 Ignoring Date Change (Reset detected)")
            ignoreDateChange = false // Reset the flag for next time
            return
        }
        
        print("📅 Date Picker Changed: Fetching single date \(date)")
        self.state = .loading
        Task {
            do {
                let photo = try await service.fetchPhoto(date: date)
                self.state = .success([photo])
            } catch {
                self.state = .error(error.localizedDescription)
            }
        }
    }
}
