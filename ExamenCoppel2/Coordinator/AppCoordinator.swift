//
//  Coordinator.swift
//  ExamenCoppel2
//
//  Created by Equipo on 04/09/23.
//


import Foundation
import UIKit


final class AppCoordinator : Coordinator{
    
    var rootViewController : UIViewController {
        
        return tabBarController
        
    }
    private let tabBarController = UITabBarController()
    override init(){
        super.init()
        let movieCoordinator = MoviesCoordinator()
        movieCoordinator.rootCoordinator.delegate = self
        let profileCoordinator = ProfileCoordinator()
        tabBarController.viewControllers = [movieCoordinator.rootCoordinator,profileCoordinator.rootViewController]
        childCoordinators.append(movieCoordinator)
        childCoordinators.append(profileCoordinator)
        setupTabBar()
        
    }
    
    override func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
       
    }
    override func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    }
    
    override func start(){
        let userIsLoggedIn = UserDefaults.standard.isUserLogged
        if !userIsLoggedIn{
            showLogin()
        }else{
            showHome()
        }
        
    }
    
    private func showLogin(){
        let loginCoordinator = LoginCoordinator(rootController: rootViewController)
        pushCoordinator(loginCoordinator)
        loginCoordinator.didFinish = { [weak self] coordinator in
            self?.popCoordinator(coordinator)
            self?.showHome()
            
        }
        
        
        
    }
    private func showHome(){
        childCoordinators.forEach { coordinator in
            coordinator.start()
        }
    }
    private func setupTabBar(){
        tabBarController.delegate = self
        tabBarController.selectedIndex = 0
        tabBarController.tabBar.isTranslucent = false
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .navigationBackGroundColor
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        tabBarController.tabBar.tintColor = .systemGreen
    }
   
    
}
extension AppCoordinator : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        tabBarController.selectedViewController = viewController

    }
}

