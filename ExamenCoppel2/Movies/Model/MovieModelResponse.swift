//
//  MovieModelResponse.swift
//  ExamenCoppel2
//
//  Created by Equipo on 08/09/23.
//

import Foundation

struct MovieModelResponse : Codable {
    let id : Int
    let original_title : String
    let overview : String
    let vote_average : Double
    let release_date : String
    let poster_path : String
}
