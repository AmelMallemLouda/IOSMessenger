//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Amel Mallem on 3/16/22.
//

import UIKit
import FirebaseAuth
//UINavigationControllerDelegate : to access camera
class RegisterViewController: UIViewController, UINavigationControllerDelegate  {

    private let imageView: UIImageView = {
        let imageVew = UIImageView()
        imageVew.image = UIImage(systemName: "person.circle")
        imageVew.tintColor = .gray
        imageVew.layer.masksToBounds = true
        imageVew.layer.borderWidth = 2
        imageVew.layer.borderColor = UIColor.lightGray.cgColor
        imageVew.contentMode = .scaleAspectFit
        return imageVew
        
    }()
  private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let firstNameField : UITextField = {
       let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = " First Name ....."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
      
        return field
    }()
    
    private let lastNameField : UITextField = {
       let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Last Name ....."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
      
        return field
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
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // subview
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        
        view.backgroundColor = .white
       title = "Log In"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector( didTapRegister))
    }
    
    
    @objc func didTapChangeProfilePic(){
        presentPhotoToActionSheet()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: ((scrollView.width-size)/2), y: 20, width: size, height: size)
        imageView.layer.cornerRadius = imageView.width/2.0
        firstNameField.frame = CGRect(x: 30, y: imageView.bottom+10, width: scrollView.width-60, height: 52)
        lastNameField.frame = CGRect(x: 30, y: firstNameField.bottom+10, width: scrollView.width-60, height: 52)
        
        emailField.frame = CGRect(x: 30, y: lastNameField.bottom+10, width: scrollView.width-60, height: 52)
      
        passwordField.frame = CGRect(x: 30, y: emailField.bottom+10, width: scrollView.width-60, height: 52)
        registerButton.frame = CGRect(x: 30, y: passwordField.bottom+10, width: scrollView.width-60, height: 52)
        
        registerButton.addTarget(self, action: #selector(registerButtonTaped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    
   // @objc private func registerButtonTaped(){
        
//        emailField.resignFirstResponder()
//        passwordField.resignFirstResponder()
//        firstNameField.resignFirstResponder()
//        lastNameField.resignFirstResponder()
//        guard let email = emailField.text , let password = passwordField.text,let firstName = firstNameField.text , let lastName = lastNameField.text,  !email.isEmpty , !password.isEmpty ,!firstName.isEmpty , !lastName.isEmpty ,password.count >= 6 else{return alertUserLoginError()}
//
//        //firebase login
//        DataBaseManager.shared.userExists(with: email, completion: {[weak self] exists in
        //            guard let strongSelf = self else{return}
        //            guard !exists else{
        //
        //
        //                //user already exists
        //                self?.alertUserLoginError(message: "Looks like a user account for that email address already exists")
        //                return
        //            }
        //
        //            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {authResult , error in
        //
        //                guard  authResult != nil , error == nil else {
        //                    print("Error creating user")
        //                    return
        //                }
        //
        //                DataBaseManager.shared.insertUser(whith: ChatAppUser(firstname: firstName, lastName: lastName, emailAddress: email))
        //
        //                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        //        })
        //
        //
        //        })
//
        
        @objc private func registerButtonTaped(){
            emailField.resignFirstResponder()
                   passwordField.resignFirstResponder()
                  firstNameField.resignFirstResponder()
                  lastNameField.resignFirstResponder()
            
            
              guard let email = emailField.text,
                    let password = passwordField.text,
                    let firstname = firstNameField.text,
                    let lastName = lastNameField.text,
                    !email.isEmpty,
                    !password.isEmpty,
                    !firstname.isEmpty,
                    !lastName.isEmpty,
                    password.count >= 6 else {
                  alertUserLoginError()
                  return
              }
            
//                DataBaseManager.shared.userExists(with: email, completion: {[weak self] exists in
//                            guard let strongSelf = self else{return}
//                            guard !exists else{
//                                strongSelf.alertUserLoginError(message: "Looks like a user account for that email address already exists")
//                                return
//                            }
                    
                    FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] authResult , error in
                        guard let strongSelf = self else {return}
                       guard  authResult != nil , error == nil else {
                            print("Error creating user")
                            return
                        }
        
                        DataBaseManager.shared.insertUser(whith: ChatAppUser(firstname: firstname, lastName: lastName, emailAddress: email))
        
                        strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                })
                //})
                
                          
                
                
                        
    }

    
    func alertUserLoginError(message : String = "Please enter all the information to Create a new account"){
        
        let Alert = UIAlertController.init(title: "Oops", message: message, preferredStyle: .alert)
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

extension RegisterViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }else if textField == passwordField {
            registerButtonTaped()
        }
            
        
        return true
    }
    
}

extension RegisterViewController : UIImagePickerControllerDelegate{
    
    func presentPhotoToActionSheet(){
        let actionSheet = UIAlertController.init(title: "Profile Picture", message: "How would you like to select a picture", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction.init(title: "Take a photo", style: .default, handler: {[ weak self]_ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Chose a photo", style: .default, handler: {[weak self]_ in
                                                    self?.presentPhotoPicker() }))
       
                                              
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera(){
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return} // can put original image but we want to edit
        self.imageView.image = selectedImage
    }
}
