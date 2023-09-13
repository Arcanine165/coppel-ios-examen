//
//  ProfileCoordinator.swift
//  ExamenCoppel2
//
//  Created by Equipo on 10/09/23.
//

import Foundation
import UIKit
final class ProfileCoordinator : Coordinator{
    var rootViewController : UIViewController {
        return navigationController
    }
    private var navigationController : UINavigationController = UINavigationController()
    
    override func start() {
        let profileViewModel = ProfileViewModel()
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        profileViewController.viewModel.didSelectMovie = {[weak self] movie in
            self?.showDetail(movieId:movie.id)

        }
        setupNavigationController()
        navigationController.pushViewController(profileViewController, animated: true)
    }
    private func showDetail(movieId : Int){
        
        let viewModel = MovieDetailViewModel(id: movieId)
        
        let movieDetailController = MovieDetailViewController(viewModel: viewModel)
        movieDetailController.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(movieDetailController, animated: true)
        
    }
    
    private func setupNavigationController(){
        navigationController.tabBarItem.title = "Profile"
        navigationController.tabBarItem.image = UIImage(systemName: "person.fill")!
    }
}
