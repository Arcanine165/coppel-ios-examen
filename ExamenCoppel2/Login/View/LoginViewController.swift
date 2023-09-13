//
//  LoginViewController.swift
//  ExamenCoppel2
//
//  Created by Equipo on 04/09/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    var backgroundImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.Login.loginBackgroundImage)!
        return imageView
    }()
    lazy var stackView : UIView = {
        let stack = UIStackView(arrangedSubviews: [userNameContainer,passwordContainer,loginButton,errorMessage])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var userNameContainer : UIView = {
        let container = Utils.shared.setupContainer(textField: userNameTextField)
        return container
    }()
    var userNameTextField : UITextField = {
        let textField = Utils.shared.setupTextField(placeholder: Constants.Login.loginPlaceHolder, isSecure: false)
        textField.text = ""
        return textField
    }()
    lazy var passwordContainer : UIView = {
        let container = Utils.shared.setupContainer(textField: passwordTextField)
        return container
    }()
    var passwordTextField : UITextField = {
        let textField = Utils.shared.setupTextField(placeholder: Constants.Login.passwordPlaceHolder, isSecure: true)
        textField.text = ""
        
        return textField
    }()
    lazy var errorMessage : UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.isHidden = true
        label.font = UIFont(name: "Arial", size: 10)
        return label
    }()
    lazy var loginButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray
        button.setTitle(Constants.Login.loginButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        button.anchor(height: 50)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.addSubview(loadingSpinner)
        loadingSpinner.anchor(right: button.rightAnchor,paddingRight: 8)
        loadingSpinner.centerY(inView: button)
        return button
    }()
    var loadingSpinner : UIActivityIndicatorView = {
        let loadingSpinner = UIActivityIndicatorView(style: .medium)
        return loadingSpinner
        
    }()
    
    var loginViewModel : LoginViewViewModel
    
    // MARK: - Initialiazer


    init(loginViewModel: LoginViewViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        setupView()
        setupListeners()
    }
     
     func setupListeners(){
         loginViewModel.didLoginSucces = {
         }
         loginViewModel.didLoginFailed = {[weak self] errorMessage in
             self?.showError(error: errorMessage)
             self?.loadingSpinner.stopAnimating()
         }
         
     }
     // MARK: - Funcs
     private func showError(error : String){
         errorMessage.isHidden = false
         errorMessage.text = error
     }

     // MARK: - View

     private func setupView(){
         view.addSubview(backgroundImage)
         view.addSubview(stackView)
         setupConstraints()
     }

     // MARK: - Constraints
     private func setupConstraints(){
         stackView.anchor(left:view.leftAnchor,right: view.rightAnchor,paddingLeft: 32,paddingRight: 32)
         stackView.center(inView: view)
         backgroundImage.anchor(top: view.topAnchor,left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor)

     }
     // MARK: - OBJC funcs
     @objc func login(){
         loadingSpinner.startAnimating()
         if !errorMessage.isHidden {
             errorMessage.isHidden = true
         }
         if let password = passwordTextField.text,let username = userNameTextField.text {
             loginViewModel.doLogin(username: username, password: password)
         }
     }
    
    private func setDelegates(){
        passwordTextField.delegate = self
        userNameTextField.delegate = self
    }
    
    private func verifyTextFields(){
        guard let username = userNameTextField.text,let password = passwordTextField.text else{
            return
        }
        if username == "" || password == ""{
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.systemGray2
        }else{
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.systemGreen
        }
        
    }
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    deinit{
        print("DEBUGG LoginViewControll deinit")
    }

}

extension LoginViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let errorMessageIsHidden = errorMessage.isHidden
        if !errorMessageIsHidden{
            errorMessage.isHidden = true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        verifyTextFields()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Ocultar el teclado cuando el usuario presiona "Return" (Intro)
        textField.resignFirstResponder()
        return true
    }
    
}
