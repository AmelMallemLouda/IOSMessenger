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
        tableView.tableHeaderView = createTableHeader()
      
    }
    func createTableHeader()-> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeEmail = DataBaseManager.safeEmail(emailAddress: email)
        let fileName = safeEmail + "_profile_picture.png"
        
        let path = "images/"+fileName
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 300))
//        view.addSubview(headerView)
        headerView.backgroundColor = .link
        let imgView = UIImageView(frame: CGRect(x: (headerView.width-150)/2, y: 75, width: 150, height: 150))
        
       
        imgView.contentMode = .scaleAspectFill
        imgView.layer.borderColor = UIColor.white.cgColor
        imgView.backgroundColor = .white
        imgView.layer.borderWidth = 0
        imgView.layer.cornerRadius = imgView.width/2
        imgView.layer.masksToBounds = true
        headerView.addSubview(imgView)
        
        StorageManager.shared.DownloadURl(for: path, completion: {[ weak self] result in
            switch result {
            case .success(let url):
                self?.downloadImage(imageView: imgView, url: url)
            case .failure(let error):
                print("Failed to get download url : \(error)")
            }
        })
        return headerView
    }
    
    func downloadImage(imageView : UIImageView, url : URL){
        
        
        URLSession.shared.dataTask(with : url , completionHandler: {data ,_ , error in
            guard let data = data , error == nil else {
                return
            }
            
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }).resume()
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
