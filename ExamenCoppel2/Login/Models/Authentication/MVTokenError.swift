//
//  MVTokenError.swift
//  ExamenCoppel2
//
//  Created by Equipo on 06/09/23.
//

import Foundation
struct MVTokenError : Codable , Error{
    
    let success : Bool
    let status_code : Int
    let status_message : String
    
}
