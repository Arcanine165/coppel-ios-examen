//
//  ProfileViewController.swift
//  ExamenCoppel2
//
//  Created by Equipo on 04/09/23.
//

import UIKit

class ProfileViewController: UIViewController {
    var viewModel : ProfileViewModel
    
    init(viewModel : ProfileViewModel){
        print("DEBUGG: ProfileView")
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        // Do any additional setup after loading the view.
        title = "Profile"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
