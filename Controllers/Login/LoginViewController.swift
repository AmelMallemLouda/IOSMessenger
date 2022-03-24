//
//  LoginViewController.swift
//  Messenger
//
//  Created by Amel Mallem on 3/16/22.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import JGProgressHUD

class LoginViewController: UIViewController {
    
    private  let spinner = JGProgressHUD(style:  .dark)
    
    private let imageView: UIImageView = {
        let imageVew = UIImageView()
        imageVew.image = UIImage(named: "logo")
        imageVew.contentMode = .scaleAspectFit
        return imageVew
        
    }()
  private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let emailField : UITextField = {
       let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = " Email Address ....."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
      
        return field
  
    }()
    
    private let passwordField : UITextField = {
       let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done // when done with password log in
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = " Password....."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
  
    }()
    
    private let LoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    
  private let googleLogInButton = GIDSignInButton()
    
    private var loginObserver: NSObjectProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: {[weak self] _ in
            guard let strongSef = self else {return}
            strongSef.navigationController?.dismiss(animated: true, completion: nil)
        })
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // subview
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(LoginButton)
        scrollView.addSubview(googleLogInButton)
        view.backgroundColor = .white
       title = "Log In"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector( didTapRegister))
    }
    
    
    deinit {
        if let observer = loginObserver{
            NotificationCenter.default.removeObserver(observer)
            return
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: ((scrollView.width-size)/2), y: 20, width: size, height: size)
        emailField.frame = CGRect(x: 30, y: imageView.bottom+10, width: scrollView.width-60, height: 52)
        passwordField.frame = CGRect(x: 30, y: emailField.bottom+10, width: scrollView.width-60, height: 52)
        LoginButton.frame = CGRect(x: 30, y: passwordField.bottom+10, width: scrollView.width-60, height: 52)
        
        LoginButton.addTarget(self, action: #selector(loginButtonTaped), for: .touchUpInside)
        
        googleLogInButton.frame = CGRect(x: 30, y: LoginButton.bottom+10, width: scrollView.width-60, height: 52)
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    
    @objc private func loginButtonTaped(){
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let email = emailField.text , let password = passwordField.text, !email.isEmpty , !password.isEmpty , password.count >= 6 else{return alertUserLoginError()}
        
        
        spinner.show(in: view)
        //firebase login
         //[weak self] to avoid retention cycle, avoid memory leak
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] authResult , error in
            
            guard let strongSelf = self else{return}
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard let result = authResult , error == nil else {
                print(" Failed to log in user with email : \(email)")
                return
            }
            
            let user = result.user
            
            UserDefaults.standard.set(email , forKey: "email")
            print("Logged in user : \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    func alertUserLoginError(){
        
        let Alert = UIAlertController.init(title: "Oops", message: "Please enter all the information to log in", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "ok", style: .default, handler: nil)
        Alert.addAction(action)
        present(Alert, animated: true, completion: nil)
        
    }
   
  @objc private  func didTapRegister(){
        
    let vc = RegisterViewController()
    vc.title = "Create Account"
    navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }else if textField == passwordField {
            loginButtonTaped()
        }
            
        
        return true
    }
    
}
