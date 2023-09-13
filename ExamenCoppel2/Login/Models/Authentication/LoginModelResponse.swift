//
//  LoginModelResponse.swift
//  ExamenCoppel2
//
//  Created by Equipo on 04/09/23.
//

import Foundation
struct LoginModelResponse : Codable {
    let success : Bool
    let expires_at : String
    let request_token : String
}
