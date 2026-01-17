//
//  APIService.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 25/12/25.
//

import Foundation

protocol APIServiceProtocol {
    func fetchPhoto(date: Date) async throws -> APODModel
    func fetchRecentPhotos(days: Int) async throws -> [APODModel]
}

class APIService: APIServiceProtocol {
    private let baseURL = "https://api.nasa.gov/planetary/apod"
    
    // 1. Fetch SINGLE Photo (For Date Picker)
    func fetchPhoto(date: Date) async throws -> APODModel {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        let urlString = "\(baseURL)?api_key=\(APIConfig.nasaAPIKey)&date=\(dateString)"
        guard let url = URL(string: urlString) else { throw APIError.invalidURL }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(APODModel.self, from: data)
    }

    // 2. Fetch GRID (Parallel Request for last 7 days)
    func fetchRecentPhotos(days: Int = 7) async throws -> [APODModel] {
        return try await withThrowingTaskGroup(of: APODModel?.self) { group in
            var results: [APODModel] = []
            
            for i in 0..<days {
                let dateToFetch = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
                group.addTask {
                    try? await self.fetchPhoto(date: dateToFetch)
                }
            }
            
            for try await photo in group {
                if let photo = photo { results.append(photo) }
            }
            
            return results.sorted { $0.date > $1.date } // Sort Newest First
        }
    }
}
