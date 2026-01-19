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
    private var apiHitCount = 0
    
    // 1. Fetch SINGLE Photo (For Date Picker)
        func fetchPhoto(date: Date) async throws -> APODModel {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: date)
            
            // ⚠️ Case 1: .invalidURL
            let urlString = "\(baseURL)?api_key=\(APIConfig.nasaAPIKey)&date=\(dateString)"
            guard let url = URL(string: urlString) else {
                print("❌ Error: URL Creation failed")
                throw APIError.invalidURL
            }
            
            apiHitCount += 1
            print("🚀 [API Request #\(apiHitCount)] Fetching: \(urlString)")
            do {
                let (data, response) = try await URLSession.shared.data(from: url)

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                print("📥 [Status: \(httpResponse.statusCode)]")
                if !(200...299).contains(httpResponse.statusCode) {
                    print("❌ API ERROR CODE: \(httpResponse.statusCode)")
                    if let errorText = String(data: data, encoding: .utf8) {
                        print("⚠️ SERVER MESSAGE: \(errorText)")
                    }
                    throw APIError.invalidResponse
                }
                return try JSONDecoder().decode(APODModel.self, from: data)

            } catch let error as APIError {
                throw error
                
            } catch is DecodingError {
                print("❌ Decoding Failed: Data didn't match APODModel")
                throw APIError.decodingError
                
            } catch {
                print("❌ Unknown Error: \(error.localizedDescription)")
                throw APIError.unknown(error)
            }
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
