//
//  MoviesCoordinator.swift
//  ExamenCoppel2
//
//  Created by Equipo on 10/09/23.
//

import Foundation
import UIKit
final class MoviesCoordinator : Coordinator {
    
    var rootCoordinator : UINavigationController {
        return navigationController
    }
    
    private var navigationController : UINavigationController = UINavigationController()
    var childController : [UIViewController] = []
    override func start() {
        let viewModel = MoviesViewViewModel()
        let moviesViewController = MoviesViewController(viewModel: viewModel)
        viewModel.didSelectMovie = {[weak self] movie in
            self?.showDetail(movieId:movie.id)
        }
        moviesViewController.navigationController?.delegate = self
        setupNavigationController()
        navigationController.pushViewController(moviesViewController, animated: true)
    }
    
    private func showDetail(movieId : Int){
        
        let viewModel = MovieDetailViewModel(id: movieId)
        
        let movieDetailController = MovieDetailViewController(viewModel: viewModel)
        movieDetailController.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(movieDetailController, animated: true)
        
    }
    override func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let moviesViewController = viewController as? MoviesViewController {
            moviesViewController.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
   
    private func setupNavigationController(){
        
        navigationController.tabBarItem.title = "Movies"
        
        navigationController.tabBarItem.image = UIImage(systemName: "house.fill")!
        
    }
    
   
   
}







