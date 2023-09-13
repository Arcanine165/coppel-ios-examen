//
//  MovieDetailViewController.swift
//  ExamenCoppel2
//
//  Created by Equipo on 10/09/23.
//

import UIKit

class MovieDetailViewController: UIViewController {
    // MARK: - Properties
    lazy var producesTitle : UILabel = {
        let label = UILabel()
        label.text = "Producers"
        label.textColor = .white
        label.isHidden = true
        label.font = UIFont(name: "Arial", size: 32)
        return label
    }()
    lazy var producesCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(MovieCompanyCollectionViewCell.self, forCellWithReuseIdentifier: MovieCompanyCollectionViewCell.identifier)
        collectionView.backgroundColor = .primaryBackgroundColor
        return collectionView
    }()
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    var mainStackView : UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    var movieViewContainer : UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleToFill
        imv.backgroundColor = .clear
        imv.adjustsImageSizeForAccessibilityContentSizeCategory = true
        imv.autoresizesSubviews = true
        imv.clipsToBounds = true
                
        return imv
    }()
    lazy var stackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieLengthView,movieRateView,movieReleaseDateView])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    lazy var movieLengthView : UIView = {
        let view = Utils.shared.propertiesViewContainer(image: "clock", label: movieDuration)
        return view
    }()
    var movieDuration : UILabel = {
        let label = UILabel()
        label.textColor = .white

        return label
    }()
    lazy var movieRateView : UIView = {
        let view = Utils.shared.propertiesViewContainer(image: "star.circle", label: movieRate)
        return view
    }()
    var movieRate : UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    lazy var movieReleaseDateView : UIView = {
        let view = Utils.shared.propertiesViewContainer(image: "calendar", label: movieRelease)
        return view
    }()
    var movieRelease : UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    var movieDescriptionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.contentMode = .topLeft
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    lazy var spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        return spinner
    }()
    
    lazy var favoriteButton : UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    // MARK: - Initializer

    var viewModel : MovieDetailViewModel
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - ViewController LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryBackgroundColor
        viewModel.delegate = self
        producesCollectionView.dataSource = viewModel
        producesCollectionView.delegate = viewModel
        spinner.startAnimating()
        viewModel.getMovieDetail()
        setup()

    }
    
    // MARK: - SetupMovie

    func setupMovie(movie : MovieDetailResponse){
        title = movie.original_title
        let movieImage = movie.poster_path
        MovieImageManager.shared.fetchImage(with: movieImage ?? "") {[weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.movieViewContainer.image = UIImage(data: image)
                }
            case .failure(let failure):
                print(failure)
            }
        }
        movieDuration.text = String(movie.runtime)
        movieRelease.text = String(movie.release_date).formatDate()
        movieRate.text = String(movie.vote_average)
        movieDescriptionLabel.text = movie.overview
    }

    // MARK: - Contraints
    private func setup(){
        view.addSubview(scrollView)
        view.addSubview(spinner)
        scrollView.addSubViews(movieViewContainer,stackView,movieDescriptionLabel,producesCollectionView,producesTitle)
        setConstraints()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+50)

    }
    private func setConstraints(){
        
        spinner.center(inView: view)
        scrollView.anchor(top: view.topAnchor,left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor)
        movieViewContainer.anchor(top: scrollView.topAnchor,left: scrollView.leftAnchor,right: scrollView.rightAnchor,width: view.frame.size.width,height: 400)
        stackView.anchor(top: movieViewContainer.bottomAnchor,left: scrollView.leftAnchor,right: scrollView.rightAnchor,paddingTop: 8,paddingLeft: 16,paddingBottom: 16,paddingRight: 16,height: 20)
        
        movieDescriptionLabel.anchor(top: stackView.bottomAnchor,left: scrollView.leftAnchor,bottom: scrollView.bottomAnchor,right: scrollView.rightAnchor,paddingTop: 8,paddingLeft: 8,paddingRight: 8,height: 150)
        
        producesTitle.anchor(top: movieDescriptionLabel.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingLeft: 8,paddingBottom: 16,paddingRight: 8)
        
        producesCollectionView.anchor(top: producesTitle.bottomAnchor,left: scrollView.leftAnchor,right: scrollView.rightAnchor,height: 150)
        
        
    }

}
// MARK: - Extensions

extension MovieDetailViewController : MovieDetailDelegate {
    func didLoadCompanies() {
        print("me cargue")
        producesTitle.isHidden = false
        DispatchQueue.main.async {[weak self] in
            
            self?.producesCollectionView.reloadData()
        }
    }
    
    func didFinishGettingMovieDetailInfo(movie: MovieDetailResponse) {
        setupMovie(movie : movie)
        spinner.stopAnimating()
    }
    
    
}


