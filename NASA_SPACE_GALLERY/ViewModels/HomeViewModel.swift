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
    case success([APODModel]) // Now holds an ARRAY
    case error(String)
}

@MainActor
class HomeViewModel: ObservableObject {
    @Published var state: ViewState = .idle
    @Published var selectedDate: Date = Date()
    private let service: APIServiceProtocol
    
    init(service: APIServiceProtocol = APIService()) {
        self.service = service
    }
    
    // Load the 7-Day Grid
    func loadRecentPhotos() {
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
    
    // Load One Specific Date
    func loadDate(_ date: Date) {
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
