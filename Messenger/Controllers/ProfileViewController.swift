//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Amel Mallem on 3/16/22.
//

import UIKit
import FirebaseAuth
import  GoogleSignIn
class ProfileViewController: UIViewController {

    
    @IBOutlet var tableView : UITableView!
    
    let data = ["Log Out"]
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    

}




extension ProfileViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for : indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let actionSheet = UIAlertController.init(title: "", message: "", preferredStyle: .actionSheet)
        
        //weak self to avoid getting stck in prestention cycle
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else{return}
            
            GIDSignIn.sharedInstance()?.signOut()
            do{
                try FirebaseAuth.Auth.auth().signOut()
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav , animated: true)        }
            catch{
                print{"Failed to log out"}
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
        
        
    }
}
