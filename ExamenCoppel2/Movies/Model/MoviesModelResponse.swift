//
//  MoviesModelResponse.swift
//  ExamenCoppel2
//
//  Created by Equipo on 08/09/23.
//

import Foundation

struct MoviesModelResponse : Codable {
    let page : Int
    let results : [MovieModelResponse]
    let total_pages : Int
    let total_results : Int
}
