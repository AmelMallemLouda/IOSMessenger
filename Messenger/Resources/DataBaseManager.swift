//
//  DataBaseManager.swift
//  Messenger
//
//  Created by Amel Mallem on 3/18/22.
//

import Foundation
import FirebaseDatabase

final class DataBaseManager{
    
    // we want  singlton class
    
    static let shared = DataBaseManager()
    private let database = Database.database().reference()
    
    
   
    
}

// Account management
extension DataBaseManager {
   
    public func userExists( with email : String, completion : @escaping ((Bool)-> Void)){
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
            guard  snapshot.value as? String != nil else{
           completion(false)
                return
            }
            completion(true)
     })
        
    }
    /// INSERTS NEW USER TO DATABASE
    public func insertUser(whith user: ChatAppUser){
        
        
        database.child(user.safeEmail).setValue(["first_Name" : user.firstname , "last_Name": user.lastName])
    }
    
    
    
}
struct ChatAppUser{
    
    let firstname : String
    let lastName : String
    let emailAddress : String
    // let profilePictureURL : String
    
    
    var safeEmail : String {

        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
