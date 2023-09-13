//
//  ProfileViewModel.swift
//  ExamenCoppel2
//
//  Created by Equipo on 10/09/23.
//

import Foundation
import UIKit
protocol ProfileViewDelegate : class {
    func didLoadUserInfo(username : String)
    func didLoadFavoriteMovies()
}
final class ProfileViewModel : NSObject {
    
    weak var delegate : ProfileViewDelegate?
    var didSelectMovie : ((MovieModelResponse)->Void)?
    private var favoriteMovieCells : [MovieCellViewModel] = []

    private var favoriteMovies : [MovieModelResponse] = [] {
        didSet {
            for movie in favoriteMovies {
                if !favoriteMovieCells.contains(where: {$0.id == movie.id}){
                    let viewModel = MovieCellViewModel(id: movie.id, movieTitle: movie.original_title, movieRate: movie.vote_average, movieDescription: movie.overview, movieImage: movie.poster_path, movieReleaseDate: movie.release_date)
                    favoriteMovieCells.append(viewModel)
                }
            }
        }
    }

    func getUserInfo(){
        let username : String = UserDefaults.standard.username ?? "Default"
        delegate?.didLoadUserInfo(username: username)
    }
    
    func getFavorites(){
        guard let userId = UserDefaults.standard.id else {
            return
        }
        let endPoint = Route.accountDetail.defaultValue + "/\(userId)" + "/favorite" + "/movies"
        Networking.shared.setRequest(route: endPoint, method: .get, type: MoviesModelResponse.self) {[weak self] result in
            switch result {
            case .success(let data):
                let movieResults = data.results
                self?.favoriteMovies = movieResults
                self?.delegate?.didLoadFavoriteMovies()
            case .failure(let failure):
                print(failure)
            }
        }
        
    }
    
    
}
extension ProfileViewModel : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            fatalError("incompatible")
        }
        cell.setup(viewModel: favoriteMovieCells[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2.3
        let height = collectionView.frame.height
        return CGSize(width: width , height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = favoriteMovies[indexPath.row]
        didSelectMovie?(movie)
    }
}
