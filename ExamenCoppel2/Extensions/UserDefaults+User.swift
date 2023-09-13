//
//  UserDefaults+User.swift
//  ExamenCoppel2
//
//  Created by Equipo on 10/09/23.
//

import Foundation
extension UserDefaults {
    enum Keys : String{
        case token
        case username
        case id
        var rawValue: String {
            switch self {
            case.token:
                return "Token"
            case.username:
                return "username"
            case .id:
                return "id"
            }
        }
    }
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.token.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    var username : String?{
        get {
            return UserDefaults.standard.string(forKey: Keys.username.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.username.rawValue)
        }
    }
    var id : Int? {
        get {
            return UserDefaults.standard.integer(forKey: Keys.id.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.id.rawValue)
        }
    }
    
    var isUserLogged : Bool {
        return username != nil
    }
}
