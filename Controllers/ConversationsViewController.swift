//
//  ViewController.swift
//  Messenger
//
//  Created by Amel Mallem on 3/16/22.
//

import UIKit
import FirebaseAuth

import JGProgressHUD


class ConversationsViewController: UIViewController {
     
    private let spinner = JGProgressHUD(style: .dark)
    private let tableView :UITableView = {
        
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self , forCellReuseIdentifier: "cell")
        
        return table

    }()
    
    private let NoConersationsLabel : UILabel = {
        let label = UILabel()
        label.text = "No conversations !"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21 ,weight : .medium)
        label.isHidden = true
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didComposeButton))
        
        view.addSubview(tableView)
        view.addSubview(NoConersationsLabel)
        fetchConversations()
        setupTableView()
    }
    
    @objc private func didComposeButton(){
        
        let vc = NewConversationViewController()
        vc.competion = {[weak self] result in
            print("\(result)")
            self?.createNewConversation(result: result)
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    private func createNewConversation(result : [String:String]){

     guard let name = result["name"],
          let email = result["email"] else {
    return }

        let vc = ChatViewController(with: email)
        vc.isNewConversation = true
        vc.title = name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)    }
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchConversations() {
        tableView.isHidden = false
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
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

extension ConversationsViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for : indexPath)
        
        cell.textLabel?.text = "Hello Word"
        cell.accessoryType =  .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController(with: "hhfyfyfgjyfgyj")
        vc.title = " Jenny Smith"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

