//
//  APIConfig.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 25/12/25.
//

import Foundation
struct APIConfig {
    static var nasaAPIKey: String {
        guard let key = Bundle.main.infoDictionary?["NASA_API_KEY"] as? String else {
            fatalError("Nasa API Key not found in Config.xcconfig")
        }
        return key
    }
}
