//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Amel Mallem on 3/16/22.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    
    var competion : (([String:String]) -> (Void))?
    private let spinner = JGProgressHUD(style: .dark)
    
    var hasFetched = false
    
    private var users = [[String : String]]()
    private var results = [[String : String]]()
    
    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = " Search for Users...."
        return searchBar
    }()
   
   
 private   let  tableView : UITableView = {
       let table = UITableView()
    table.isHidden = true
    table.register(UITableViewCell.self , forCellReuseIdentifier: "cell")
    return table
 }()
    
    private let noResultLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = " No results"
        label.textAlignment = .center
        label.textColor = .green
        label.font = .systemFont(ofSize: 21 , weight : .medium)
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(noResultLabel)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        view.backgroundColor = .white
        
        // this will put the search bar in the navigation bar
        
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector(selfDismiss))
        searchBar.becomeFirstResponder()
    }
    
    @objc private func selfDismiss(){
        dismiss(animated: true, completion: nil)
    }
  
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        noResultLabel.frame = CGRect(x: view.width/4,
                                     y: (view.hight-200)/2,
                                     width: view.width/2,
                                     height: 200)
    }
}

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for : indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let targetUserData = results[indexPath.row]
        dismiss(animated: true, completion: {[weak self] in
            // start conversation
            self?.competion?(targetUserData)
        })
        
     
       
    }
    //, !text.replacingOccurrences(of: " ", with: "").isEmpty
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        guard let text = searchBar.text  else{
       return
    }
    
        searchBar.resignFirstResponder()
        
        results.removeAll()
        
        spinner.show(in : view)

        self.searchUsers(query : text)
}
    func searchUsers(query : String){
        
        // check if array has firebase results
        if hasFetched{
            //if it does : filter
            filterUsers(with: query)
        }else{
            //if not , fetch then filter
            DataBaseManager.shared.getAllUsers(completion: {[weak self] result in
                switch result {
                case .success(let userCollection):
                    self?.hasFetched = true
                    self?.users = userCollection
                    self?.filterUsers(with: query)
                case . failure(let error):
                    print("Failed to get users : \(error)")
                }
            })
        }
        
        
      
    }
    
    
    
    
    func filterUsers(with term : String){
        // update the UI : either show results or show no
        guard hasFetched else {
            return
        }
        self.spinner.dismiss()
        let results : [[String:String]] = self.users.filter ({
            guard let name = $0["name"]?.lowercased()  else {
                return false
        }
            return name.hasPrefix(term.lowercased())
        })
        self.results = results
        updateUI()
    }
    
    func updateUI(){
        
        if results.isEmpty{
            self.noResultLabel.isHidden = false
            self.tableView.isHidden = true
        }else{
            self.noResultLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}


