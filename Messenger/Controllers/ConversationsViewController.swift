//
//  ViewController.swift
//  Messenger
//
//  Created by Amel Mallem on 3/16/22.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        view.backgroundColor = .red
        
    }

    override func viewDidAppear(_ animated : Bool){
        
        super.viewDidAppear(animated)
        validationAuth()
        
        
      
    }
    
    
    
    private func validationAuth(){
        
        // if the user is not logged in
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav , animated: false)
        }
    }
    
    
}

