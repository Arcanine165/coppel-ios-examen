//
//  MovieCellViewModel.swift
//  ExamenCoppel2
//
//  Created by Equipo on 09/09/23.
//

import Foundation

final class MovieCellViewModel : Hashable{
    static func == (lhs: MovieCellViewModel, rhs: MovieCellViewModel) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(movieTitle)
        hasher.combine(movieRate)
        hasher.combine(movieImage)
        hasher.combine(movieDescription)
        hasher.combine(movieReleaseDate)
    }
    let id : Int
    let movieTitle : String
    let movieRate : Double
    let movieDescription : String
    let movieImage : String
    let movieReleaseDate : String
    
    init(id : Int,movieTitle: String, movieRate: Double, movieDescription: String, movieImage: String, movieReleaseDate: String) {
        self.id = id
        self.movieTitle = movieTitle
        self.movieRate = movieRate
        self.movieDescription = movieDescription
        self.movieImage = movieImage
        self.movieReleaseDate = movieReleaseDate
    }
    
    func fetchImage(competion : @escaping (Result<Data,Error>) -> Void){
        MovieImageManager.shared.fetchImage(with: movieImage,completion: competion)
    }
    
}
