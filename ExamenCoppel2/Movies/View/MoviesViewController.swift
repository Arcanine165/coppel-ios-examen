//
//  MovieViewController.swift
//  ExamenCoppel2
//
//  Created by Equipo on 04/09/23.
//

import UIKit

class MoviesViewController: UIViewController {
    var viewModel : MoviesViewViewModel
    
    init(viewModel: MoviesViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var categorySementedControl : UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        let unselectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        segmentedControl.setTitleTextAttributes(unselectedTextAttributes, for: .normal)
        segmentedControl.insertSegment(withTitle: Constants.Movie.popularSegment, at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: Constants.Movie.topRatedSegment, at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: Constants.Movie.onTvSegment, at: 2, animated: true)
        segmentedControl.insertSegment(withTitle: Constants.Movie.airingTodaySegment, at: 3, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

        return segmentedControl

    }()
    private var moviesCollectionView : UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.register(FooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCollectionReusableView.identifier)
        collectionView.backgroundColor = .primaryBackgroundColor
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.Movie.title
        self.addConstraints()
        view.backgroundColor = .primaryBackgroundColor
        
        moviesCollectionView.delegate = viewModel
        moviesCollectionView.dataSource = viewModel
        viewModel.delegate = self
        viewModel.fetchData(.popular)
       
    }
  
    
    // MARK: - Constraints

    private func addConstraints(){
        view.addSubview(moviesCollectionView)
        view.addSubview(categorySementedControl)
        categorySementedControl.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 8,paddingLeft: 8,paddingBottom: 8,paddingRight: 8,height: 50)
        moviesCollectionView.anchor(top: categorySementedControl.bottomAnchor,left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingTop: 16)
    }
    
    // MARK: - OBJC Functions
    @objc func segmentedControlValueChanged() {
        let selectedIndex = categorySementedControl.selectedSegmentIndex
        if !moviesCollectionView.visibleCells.isEmpty {
            let indexPath = IndexPath(item: 0, section: 0)
            moviesCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
        updateCategoryAndFetchData(selectedIndex: selectedIndex)
        
        
        
    }
    func updateCategoryAndFetchData(selectedIndex: Int) {
        
        switch selectedIndex {
        case 0:
            viewModel.fetchData(.popular)
            viewModel.category = .popular
            
        case 1:
            viewModel.fetchData(.topRated)
            viewModel.category = .topRated
        case 2:
            viewModel.fetchData(.onTheAir)
            viewModel.category = .onTheAir
        case 3:
            viewModel.fetchData(.airingToday)
            viewModel.category = .airingToday
        default:
            print("Invalid index")
        }
        DispatchQueue.main.async {[weak self] in
            self?.moviesCollectionView.reloadData()
        }
    }
 

}
extension MoviesViewController : MoviesViewModelDelegate {
    func didStartFetchingMoreMovies() {
        categorySementedControl.isEnabled = false
    }
    func didFailedFetchingMoreMovies(){
        categorySementedControl.isEnabled = true
    }
    func didFetchMoreMovies(newSet : [IndexPath]) {
            DispatchQueue.main.async { [weak self] in
                self?.moviesCollectionView.insertItems(at: newSet)
                self?.categorySementedControl.isEnabled = true

            }
        
       
    } 
    func didFecthInitialMoviesSuccessFully() {
        DispatchQueue.main.async {[weak self] in
            self?.moviesCollectionView.reloadData()

        }
    }
    
    
}
