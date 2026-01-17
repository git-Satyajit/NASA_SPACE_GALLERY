//
//  APODModel.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 25/12/25.
//

import Foundation

struct APODModel: Codable, Identifiable {
    var id: String { date }
    let date: String
    let title: String
    let explanation: String
    let url: String
    let mediaType: String
    
    // ⚠️ CHANGED: Made these Optional to prevent decoding crashes
    let hdurl: String?
    let copyright: String?
    let serviceVersion: String?

    enum CodingKeys: String, CodingKey {
        case date, title, explanation, url, hdurl, copyright
        case mediaType = "media_type"
        case serviceVersion = "service_version"
    }
}
