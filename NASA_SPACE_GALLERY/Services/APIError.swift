//
//  APIError.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 25/12/25.
//

import Foundation
enum APIError: Error,LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case unknown(Error)
    var errorDescription: String? {
        switch self {
            case .invalidURL: return "The URL is Invalid"
            case .invalidResponse: return "Server Responded with An Error"
            case .decodingError: return "Failed to decode"
            case .unknown(let error):return error.localizedDescription
        }
    }
}
