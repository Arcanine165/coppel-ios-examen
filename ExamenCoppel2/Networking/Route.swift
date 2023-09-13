//
//  Route.swift
//  ExamenCoppel2
//
//  Created by Equipo on 10/09/23.
//

import Foundation
enum Route : String {
    case tokenURL = "/authentication/token/new"
    case loginURL
    case authenticate
    case accountDetail
    case topRated
    case onTheAir
    case popular
    case airingToday
    case movieDetail
    
    var defaultValue: String {
        switch self {
        case .tokenURL :
            return "/authentication/token/new"
        case .loginURL:
            return "/authentication/token/validate_with_login"
        case .authenticate :
            return "/authentication/session/new"
        case .accountDetail :
            return "/account"
        case .topRated :
            return "/movie/top_rated"
        case .popular :
            return "/movie/popular"
        case .airingToday :
            return "/movie/now_playing"
        case.onTheAir :
            return "/movie/upcoming"
        case .movieDetail:
            return "/movie/"
        }
    }
}
