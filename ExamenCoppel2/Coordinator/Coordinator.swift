//
//  File.swift
//  ExamenCoppel2
//
//  Created by Equipo on 10/09/23.
//

import Foundation

import UIKit

class Coordinator: NSObject, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    var didFinish: ((Coordinator) -> Void)?
    
    
    var childCoordinators: [Coordinator] = []

    // MARK: - Methods
    
    func start() {}
    
  
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {}

    
    
    func pushCoordinator(_ coordinator: Coordinator) {
        coordinator.didFinish = { [weak self] (coordinator) in
            self?.popCoordinator(coordinator)
        }
        
        coordinator.start()
        
        childCoordinators.append(coordinator)
    }
    
    func popCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }

}
