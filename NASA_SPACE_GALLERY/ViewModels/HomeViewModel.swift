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
    case success(APODModel)
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
    
    func loadTodaysPhoto() {
        fetchPhoto(for: Date())
    }
    
    func updateDate(to date: Date) {
        self.selectedDate = date
        fetchPhoto(for: date)
    }
    
    private func fetchPhoto(for date: Date) {
        self.state = .loading
        
        Task {
            do {
                let data = try await service.fetchPhoto(date: date)
                self.state = .success(data)
                
            } catch {
                self.state = .error(error.localizedDescription)
            }
        }
    }
}
