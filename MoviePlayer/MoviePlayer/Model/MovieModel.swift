//
//  MovieModel.swift
//  MoviePlayer
//
//  Created by Madeleine Sekar Putri Wijayanto on 04/10/24.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let imageURL: String
    let title: String
    let shortDescription: String
    let longSynopsis: String
    let filterTags: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case title
        case shortDescription = "short_description"
        case longSynopsis = "long_synopsis"
        case filterTags
    }
}
