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
        navigationController.pushViewController(profileViewController, animated: true)
        setupNavigationController()
    }
    
    private func setupNavigationController(){
        navigationController.tabBarItem.title = "Profile"
        navigationController.tabBarItem.image = UIImage(systemName: "person.fill")!
    }
}
