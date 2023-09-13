//
//  Utils.swift
//  ExamenCoppel2
//
//  Created by Equipo on 04/09/23.
//

import Foundation
import UIKit
struct Utils {
    static let shared = Utils()
    
    private init(){}
    
    func setupContainer(textField : UITextField) -> UIView{
        let view = UIView()
        view.addSubview(textField)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        textField.anchor(top: view.topAnchor,left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingLeft: 8)
        return view
    }
    func setupTextField(placeholder : String,isSecure : Bool)->UITextField{
        let textField = UITextField()
        
        let attributesPlaceHolder : [NSAttributedString.Key : Any] = [.font : UIFont(name: "Arial", size: 16) as Any, .foregroundColor : UIColor.systemGray2]
        let attributedPlaceHolder = NSAttributedString(string: placeholder,attributes: attributesPlaceHolder)
        textField.attributedPlaceholder = attributedPlaceHolder
        textField.isSecureTextEntry = isSecure
        textField.anchor(height: 50)
        return textField
    }
    func propertiesViewContainer(image : String,label : UILabel) -> UIView {
        let view = UIView()
        let iv = UIImageView()
        iv.tintColor = .systemGreen
        iv.image = UIImage(systemName: image)!.withRenderingMode(.alwaysTemplate)
        let label = label
        view.addSubview(iv)
        view.addSubview(label)
        iv.anchor(left: view.leftAnchor,paddingTop: 8,paddingBottom: 8,width: 18,height: 18)
        label.anchor(left: iv.rightAnchor,right: view.rightAnchor,paddingTop: 8,paddingLeft: 16,paddingBottom: 8,height: 18)
        return view
    }
}
