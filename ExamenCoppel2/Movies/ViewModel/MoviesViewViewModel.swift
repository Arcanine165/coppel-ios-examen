//
//  MoviesViewViewModel.swift
//  ExamenCoppel2
//
//  Created by Equipo on 07/09/23.
//

import Foundation
import UIKit
enum MovieCategory : String{
    case popular
    case topRated
    case onTv
    case airingToday
    
}

protocol MoviesViewModelDelegate : class {
    func didFecthInitialMoviesSuccessFully()
    func didFetchMoreMovies(newSet : [IndexPath])
    func didStartFetchingMoreMovies()
    func didFailedFetchingMoreMovies()

}

final class MoviesViewViewModel : NSObject{
    
    override init() {
        print("DEBUGG INIT VIEWVIEWMODEL")
    }
    
    // MARK: - Attributes

    var didFecthSuccesFully : (()->Void)?
    var didSelectMovie : ((MovieModelResponse)->Void)?
    var movieCellViewModels : [MovieCellViewModel] = []
    weak var delegate : MoviesViewModelDelegate?
    var category : Route = Route.popular
    var isFetchingMoreMovies : Bool = false
    var page : Int = 1
    var totalPages : Int = 500
    var changeState = false
    var footer : FooterCollectionReusableView!
    var movies : [MovieModelResponse] = [] {
        didSet{
            for movie in movies {
                if !movieCellViewModels.contains(where: {$0.id == movie.id && $0.movieTitle == movie.original_title}){
                    let viewModel = MovieCellViewModel(id: movie.id, movieTitle: movie.original_title, movieRate: movie.vote_average, movieDescription: movie.overview, movieImage: movie.poster_path, movieReleaseDate: movie.release_date)
                    movieCellViewModels.append(viewModel)
                }
                else{
                    print(movieCellViewModels.first(where: {$0.id == movie.id && $0.movieTitle == movie.original_title})?.movieTitle)
                }
                
            }
            print(movieCellViewModels.count)
        }
    }
    
    func fetchData(_ category : Route){
        print("DEBUGG: fetchinitialdata")

        movieCellViewModels = []
        movies = []
        page = 2
        changeState = true
        let categoryData = category.defaultValue
        Networking.shared.setRequest(route: categoryData, method: .get,type: MoviesModelResponse.self,parameters: ["page":"\(page)"]) {[weak self] result in
            switch result {
            case .success(let data):
                let results = data.results
                if results.isEmpty {
                    print("nimodo")
                    self?.delegate?.didFailedFetchingMoreMovies()
                    
                }else{
                    self?.movies = results
                    print(results)
                    self?.delegate?.didFecthInitialMoviesSuccessFully()
                    self?.page = data.page
                    self?.changeState = false
                }
               
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func fetchMoreMovies(){
        print("DEBUGG: FETCHINGMOREMOVIES")
        
        print("actual \(self.page) totalPage : \(totalPages)")
        guard self.page <= self.totalPages else {
            print("no buscara mas")
            footer.stopFetching()
            delegate?.didFailedFetchingMoreMovies()
            return
        }
        self.page = page + 1
        isFetchingMoreMovies = true
        getMovies(category: category) {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                let movies = data.results
                let newMovies = data.results.count
                let previousTotalMovies = self.movies.count
                let newTotal = newMovies + previousTotalMovies
                print(newTotal)
                let newSet =  Array(previousTotalMovies..<newTotal).compactMap { num in
                    return IndexPath(item: num, section: 0)
                }
                
                self.movies.append(contentsOf: movies)
               
                self.delegate?.didFetchMoreMovies(newSet : newSet)
                self.isFetchingMoreMovies = false
                
            case .failure(let failure):
                print(failure)
                self.isFetchingMoreMovies = false
            }
        }
        
    }
    private func getMovies(category : Route,completion : @escaping (Result<MoviesModelResponse,MVTokenError>)->Void){
        Networking.shared.setRequest(route: category.defaultValue, method: .get,type: MoviesModelResponse.self,parameters: ["page":"\(page)"],completion: completion)
    }
    
    deinit{
        print("DEBUGG Movies deinit")
    }
    
}
extension MoviesViewViewModel : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            fatalError("Unsuported cell")
        }
        let movie = movieCellViewModels[indexPath.row]
        cell.setup(viewModel: movie)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(width: width, height: width * 2.0)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = movies[indexPath.row]
        print("diste click")
        didSelectMovie?(cell)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if movieCellViewModels.isEmpty{
            return
        }
       
        let offset = scrollView.contentOffset.y
        
        let contenSize = scrollView.contentSize.height
        
        let totalScrollViewHeigth = scrollView.frame.size.height
        let bottom = (contenSize-totalScrollViewHeigth+20)
        if offset >= bottom{
            self.delegate?.didStartFetchingMoreMovies()
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) {[weak self] timer in
                
                guard let self = self else {
                    return
                }
                if !self.isFetchingMoreMovies {
                    self.fetchMoreMovies()
                }
                timer.invalidate()
            }
        
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
         footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterCollectionReusableView.identifier, for: indexPath) as! FooterCollectionReusableView
        footer.startFetching()
        return footer
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard !isFetchingMoreMovies else {
            print("zero")
            return .zero
        }
        
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
}
