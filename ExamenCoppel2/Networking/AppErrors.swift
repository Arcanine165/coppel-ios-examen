//
//  AppErrors.swift
//  ExamenCoppel2
//
//  Created by Equipo on 10/09/23.
//

import Foundation
enum AppError : Error {
    case unknownError
    case errorDecoding
    var localizedDescription : String {
        switch self {
        case .unknownError:
            return "Who knows what happened?"
        case .errorDecoding:
            return "valio madre decodificando"
        }
    }
}
