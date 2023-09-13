//
//  Constants.swift
//  ExamenCoppel2
//
//  Created by Equipo on 11/09/23.
//

import Foundation
import UIKit

struct Constants {
    private init(){}
    
    static let movieInformationLabelsColor : UIColor = UIColor.systemGreen
    static let padding : CGFloat = 10
    
    struct Login{
        private init(){}
        
        static let loginPlaceHolder = "Username"
        static let passwordPlaceHolder = "Password"
        static let loginBackgroundImage = "movie_background_image"
        static let loginButtonTitle = "Login"
       
    }
    struct Movie {
        private init(){}
        static let title = "Movies"
        static let popularSegment = "Popular"
        static let topRatedSegment = "Top Rated"
        static let onTvSegment = "On TV"
        static let airingTodaySegment = "Airing Today"
    }
}
