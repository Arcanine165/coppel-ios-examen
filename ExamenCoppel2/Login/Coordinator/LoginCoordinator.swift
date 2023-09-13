//
//  LoginCoordinator.swift
//  ExamenCoppel2
//
//  Created by Equipo on 10/09/23.
//

import Foundation
import UIKit

final class LoginCoordinator : Coordinator {
    init(rootController : UIViewController) {
        self.rootController = rootController
        super.init()
        
        
    }
    // MARK: - Properties
    
    
    
    // MARK: - Public API
    var rootController : UIViewController
    
    override func start() {
        let loginViewModel = LoginViewViewModel()
        let loginViewController = LoginViewController(loginViewModel: loginViewModel)
        loginViewController.modalPresentationStyle = .fullScreen
        rootController.present(loginViewController, animated: true)
        loginViewModel.didLoginSucces = {[weak self] in
            self?.rootController.dismiss(animated: true)
            self?.didFinish?(self!)
            
        }
        
    }
        
}
