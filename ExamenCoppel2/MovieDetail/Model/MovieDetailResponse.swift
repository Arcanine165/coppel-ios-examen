//
//  MovieDetailResponse.swift
//  ExamenCoppel2
//
//  Created by Equipo on 11/09/23.
//

import Foundation

struct Genre : Codable {
    let id : Int?
    let name : String?
}
struct Company : Codable{
    let id : Int
    let logo_path : String?
    let name : String
    let origin_country : String
}
struct MovieDetailResponse : Codable {
    let adult : Bool
    let poster_path : String?
    let budget : Int?
    let genres : [Genre]?
    let id : Int
    let original_title : String
    let overview : String
    let popularity : Double
    let production_companies : [Company]?
    let release_date : String
    let runtime : Int
    let revenue : Int
    let status : String
    let title : String
    let vote_average : Double
}
    
    
    
   
    
    
    
