//
//  ProfileViewController.swift
//  ExamenCoppel2
//
//  Created by Equipo on 04/09/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    lazy var favoriteMoviesCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.backgroundColor = .primaryBackgroundColor
        return collectionView
        
    }()
     lazy var favoriteHeader : UILabel = {
        let tv = UILabel()
         tv.text = Constants.Profile.favoritesHeader
        tv.font = UIFont.systemFont(ofSize: 26)
         tv.textColor = .systemGreen
        
        return tv
    }()
    
     lazy var profileInfoContainer : UIView = {
        let uv = UIView()
        let container = UIView()
        uv.addSubViews(container)
        uv.addSubViews(profileNameContainer,profilePicture)
        profilePicture.anchor(top: container.topAnchor,left: container.leftAnchor,width: 100,height: 100)
        profileNameContainer.anchor(left: profilePicture.rightAnchor,paddingRight: 8)
        profileName.centerY(inView: profilePicture)
        container.centerYAnchor.constraint(equalTo: uv.centerYAnchor).isActive = true
        container.translatesAutoresizingMaskIntoConstraints = false
        uv.translatesAutoresizingMaskIntoConstraints = false
        return uv
    }()
    
    
     lazy var profilePicture : UIImageView = {
        let imv = UIImageView()
         imv.tintColor = .systemGreen
         imv.image = Constants.Profile.profileImage
        imv.layer.cornerRadius = 30
        imv.contentMode = .scaleToFill
        imv.clipsToBounds = true
        return imv
    }()
    
     lazy var profileNameContainer : UIView = {
        let uv = UIView()
        uv.addSubview(profileName)
         uv.backgroundColor = .primaryBackgroundColor
        profileName.anchor(top: uv.topAnchor,left: uv.leftAnchor,bottom: uv.bottomAnchor,right: uv.rightAnchor)
        return uv
    }()
    lazy var profileName : UILabel = {
        let tv = UILabel()
        tv.font = UIFont.boldSystemFont(ofSize: 26)
        tv.textColor = .systemGreen
        return tv

    }()
    
    
    var viewModel : ProfileViewModel
    
    
    init(viewModel : ProfileViewModel){
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
        title = Constants.Profile.title
        viewModel.delegate = self
        favoriteMoviesCollectionView.dataSource = viewModel
        favoriteMoviesCollectionView.delegate = viewModel
        viewModel.getUserInfo()
        viewModel.getFavorites()
        
        setupUI()
        setupConstraints()
        
    }
    
    private func setupUI(){
        view.backgroundColor = .primaryBackgroundColor
        view.addSubview(profileInfoContainer)
        view.addSubview(favoriteMoviesCollectionView)
        view.addSubview(favoriteHeader)
            
    }
    private func setupConstraints(){
        profileInfoContainer.anchor(left:view.leftAnchor,right: view.rightAnchor,height: 300)
        favoriteMoviesCollectionView.anchor(left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingLeft: 8,paddingBottom: 8,paddingRight: 8,height: 300)
        favoriteHeader.anchor(left:view.leftAnchor,bottom: favoriteMoviesCollectionView.topAnchor,right: view.rightAnchor,height: 50)
       
    }
    

    

}
extension ProfileViewController : ProfileViewDelegate {
    func didLoadFavoriteMovies() {
        DispatchQueue.main.async {[weak self] in
            self?.favoriteMoviesCollectionView.reloadData()
            
        }
    }
    
    func didLoadUserInfo(username: String) {
        profileName.text = "Bienvenido, \(username)"
    }
    
    
}
