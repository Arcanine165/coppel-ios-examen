//
//  MovieDetailViewModel.swift
//  ExamenCoppel2
//
//  Created by Equipo on 11/09/23.
//

import Foundation
import UIKit

protocol MovieDetailDelegate : class {
    func didFinishGettingMovieDetailInfo(movie : MovieDetailResponse)
    func didLoadCompanies()

}
final class MovieDetailViewModel : NSObject {
    
    var id : Int
    weak var delegate : MovieDetailDelegate?
    init(id: Int) {
        self.id = id
    }
    var companies : [Company] = []
    
    func getMovieDetail(){
        let route = Route.movieDetail.defaultValue + "\(id)"
        Networking.shared.setRequest(route: route, method: .get, type: MovieDetailResponse.self) {[weak self] result in
            switch result {
            case .success(let movie):
                let companies = movie.production_companies
                
                if companies != nil {
                    self?.companies.append(contentsOf: companies!)
                    self?.delegate?.didLoadCompanies()
                }
                
                self?.delegate?.didFinishGettingMovieDetailInfo(movie: movie)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    
    
    
}
extension MovieDetailViewModel : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCompanyCollectionViewCell.identifier, for: indexPath) as! MovieCompanyCollectionViewCell
        let company = companies[indexPath.row]
        cell.setup(company: company)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
}

