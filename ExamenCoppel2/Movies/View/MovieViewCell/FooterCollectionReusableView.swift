//
//  FooterCollectionReusableView.swift
//  ExamenCoppel2
//
//  Created by Equipo on 11/09/23.
//

import UIKit

class FooterCollectionReusableView: UICollectionReusableView {
    static let identifier = "LoadingSpinner"
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        addSubview(spinner)
    }
    private func setupConstraints(){
        spinner.center(inView: self)
    }
    public func startFetching(){
        spinner.startAnimating()
    }
    public func stopFetching(){
        spinner.stopAnimating()
    }
}
