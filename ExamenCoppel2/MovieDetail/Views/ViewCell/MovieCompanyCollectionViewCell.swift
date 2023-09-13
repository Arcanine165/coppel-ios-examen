//
//  MovieCompanyCollectionViewCell.swift
//  ExamenCoppel2
//
//  Created by Equipo on 11/09/23.
//

import UIKit

class MovieCompanyCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCompanyCollectionViewCell"
    lazy var cardView : UIView = {
        let view = UIView()
        view.backgroundColor = .movieViewCellBackgroundColor
        view.clipsToBounds = false
        view.layer.cornerRadius = 20
        view.layer.shadowRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        
        return view
    }()
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .white
        imageView.layer.cornerRadius = 150
        return imageView
    }()
    lazy var companyName : UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        companyName.text = nil
    }
    
    func setup(company : Company){
        if company.logo_path != nil {
            MovieImageManager.shared.fetchImage(with: company.logo_path!) {[weak self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.imageView.image = UIImage(data: data)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self?.imageView.image = UIImage(named: "Image_not_available")
                    }
                }
            }
        }else{
            imageView.image = UIImage(named: "Image_not_available")
        }
        
        companyName.text = company.name
    }
    func setupConstraints(){
        addSubview(cardView)
        cardView.addSubview(companyName)
        cardView.addSubview(imageView)
        cardView.anchor(top: topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor)
        companyName.anchor(left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,height: 30)
        imageView.anchor(top: topAnchor,left: leftAnchor,bottom: companyName.topAnchor,right: rightAnchor,width: 150, height: 150)
    }
}
