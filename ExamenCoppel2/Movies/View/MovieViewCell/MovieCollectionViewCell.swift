//
//  MovieCollectionViewCell.swift
//  ExamenCoppel2
//
//  Created by Equipo on 09/09/23.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    lazy var view : UIView = {
        let view = UIView()
        view.backgroundColor = .movieViewCellBackgroundColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 0.5
        view.layer.cornerRadius = 30
        view.addSubViews(movieImageContainer,movieTitle,movieInformationStack,movieDescription)
        movieDescription.anchor(left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingTop: Constants.padding,paddingLeft: Constants.padding,paddingBottom: Constants.padding,paddingRight: Constants.padding)
        movieInformationStack.anchor(left: view.leftAnchor,bottom: movieDescription.topAnchor,right: view.rightAnchor,paddingTop: Constants.padding,paddingLeft: 8,paddingBottom: Constants.padding,paddingRight: 8)
        movieTitle.anchor(left: view.leftAnchor,bottom: movieInformationStack.topAnchor,right: view.rightAnchor,paddingTop: 8,paddingLeft: 8,paddingRight: 8,height: 34)
        movieImageContainer.anchor(top: view.topAnchor,left: view.leftAnchor,bottom: movieTitle.topAnchor,right: view.rightAnchor,paddingBottom: 8)
        
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var movieImageContainer : UIView = {
        let containerView = UIView()
        containerView.clipsToBounds = false
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 3
        containerView.addSubview(movieImage)
        movieImage.anchor(top: containerView.topAnchor,left: containerView.leftAnchor,bottom: containerView.bottomAnchor,right: containerView.rightAnchor)
        return containerView
    }()
    var movieImage : UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleToFill
        imv.clipsToBounds = false
        imv.layer.masksToBounds = true
        imv.layer.cornerRadius = 30

        return imv
    }()
    var movieTitle : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont(name: "Arial", size: 14)
        label.textColor = Constants.movieInformationLabelsColor
        return label
    }()
    lazy var movieInformationStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [movieReleaseDate,movieRateView])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .equalSpacing
        return stack
    }()
    var movieReleaseDate : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 12)
        label.textColor = Constants.movieInformationLabelsColor
        return label
    }()
   lazy var movieRateView : UIStackView = {
       let star = UIImage(systemName: "star.fill")!.withRenderingMode(.alwaysTemplate)
        let starImageView = UIImageView(image: star)
        starImageView.tintColor = .systemGreen
       starImageView.contentMode = .scaleToFill
        let stackView = UIStackView(arrangedSubviews: [starImageView,movieRateLabel])
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .fill
        return stackView
    }()
    var movieRateLabel : UILabel = {
        let movieRateLabel = UILabel()
        movieRateLabel.font = UIFont(name: "Arial", size: 12)
        movieRateLabel.textColor = Constants.movieInformationLabelsColor
        return movieRateLabel
    }()
    var movieDescription : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "Arial", size: 10)
        label.numberOfLines = 4
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = nil
        movieTitle.text = nil
        movieReleaseDate.text = nil
        movieDescription.text = nil
        movieRateLabel.text = nil
    }
    
    
    // MARK: - SetupViews
    private func setupConstraints(){
        addSubview(view)
        view.anchor(top: topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor)
    }
    
    public func setup(viewModel : MovieCellViewModel){
        viewModel.fetchImage(){[weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.movieImage.image = UIImage(data: data)
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.movieImage.image = UIImage(named: "Image_not_available")
                }
            }
        }
        
        movieTitle.text = viewModel.movieTitle
        movieReleaseDate.text = viewModel.movieReleaseDate.formatDate()
        movieDescription.text = viewModel.movieDescription
        movieRateLabel.text = String(viewModel.movieRate)
        
    }
    

}
