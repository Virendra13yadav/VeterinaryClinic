//
//  Model.swift
//  VeterinaryClinic
//
//  Created by Apple on 26/11/25.
//

import Foundation

struct SettingsResponse: Codable {
    let settings: Settings
}

struct Settings: Codable {
    let isCallEnabled: Bool
    let isChatEnabled: Bool
    let workHours: String
}

struct AllPets: Codable {
    let pets: [Pet]
}

struct Pet: Codable, Identifiable {
    let id: UUID = UUID()
    let contentURL: String
    let dateAdded: String
    let imageURL: String
    let title: String

    var imageNSURL: URL? {
        URL(string: imageURL)
    }

    enum CodingKeys: String, CodingKey {
        case contentURL = "content_url"
        case dateAdded = "date_added"
        case imageURL = "image_url"
        case title
    }
}

