//
//  APIService.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 25/12/25.
//

import Foundation

protocol APIServiceProtocol {
    func fetchPhoto(date: Date?) async throws -> APODModel
}
class APIService: APIServiceProtocol {
    
    private let baseURL = "https://api.nasa.gov/planetary/apod"
    
    func fetchPhoto(date: Date? = nil) async throws -> APODModel {
        guard var components = URLComponents(string: baseURL) else {
            throw APIError.invalidURL
        }
        var queryItems = [
            URLQueryItem(name: "api_key", value: APIConfig.nasaAPIKey)
        ]
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: date)
            queryItems.append(URLQueryItem(name: "date", value: dateString))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        do {
           

            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            if !(200...299).contains(httpResponse.statusCode) {
                print("❌ API ERROR CODE: \(httpResponse.statusCode)")
                if let errorText = String(data: data, encoding: .utf8) {
                    print("❌ API MESSAGE: \(errorText)")
                }
                
                throw APIError.invalidResponse
            }
            let decodedData = try JSONDecoder().decode(APODModel.self, from: data)
            return decodedData
            
        } catch is DecodingError {
            throw APIError.decodingError
        } catch {
            throw APIError.unknown(error)
        }
    }
}
