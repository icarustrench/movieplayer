//
//  MovieCategory.swift
//  MoviePlayer
//
//  Created by Madeleine Sekar Putri Wijayanto on 08/10/24.
//

import Foundation

struct MovieCategory: Decodable {
    let title: String
    let movies: [Movie]
}
