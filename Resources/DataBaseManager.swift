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
    
    
    static func safeEmail(emailAddress : String)-> String {
    var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
    safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
    return safeEmail
    }
    
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
//    public func insertUser(whith user: ChatAppUser , completion : @escaping (Bool)-> Void){
//
//        database.child(user.safeEmail).setValue(["first_Name" : user.firstname , "last_Name": user.lastName] , withCompletionBlock: {error , _ in
//                                                guard error == nil else {
//        print("Failed to write to database")
//        completion(false)
//        return
//            }
//            self.database.child("users").observeSingleEvent(of: .value, with: {snapshot in
//
//                if var userCollection = snapshot.value as? [[String : String]]{
//
//                //append to user dictionary
//                    let newElement =  [
//                        "name": user.firstname + " " + user.lastName,
//                        "email": user.safeEmail
//                       ]
//                    userCollection.append(newElement)
//                    self.database.child("users").setValue(userCollection , withCompletionBlock:  { error, _ in
//
//                        guard error == nil else {
//                            completion(false)
//                            return
//                        }
//                        completion(true)
//                    })
//            }else{
//            //create array dictionary
//            let newCollection : [[String: String]] = [
//              [
//                "name": user.firstname + " " + user.lastName,
//                "email": user.safeEmail
//               ]
//            ]
//                self.database.child("user").setValue(newCollection , withCompletionBlock:  { error, _ in
//
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//                    completion(true)
//                })
//            }
//            })
//    })
//    }
    
    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstname,
            "last_name": user.lastName
        ], withCompletionBlock: { [weak self] error, _ in

            guard let strongSelf = self else {
                return
            }

            guard error == nil else {
                print("failed ot write to database")
                completion(false)
                return
            }

            strongSelf.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    // append to user dictionary
                    let newElement = [
                        "name": user.firstname + " " + user.lastName,
                        "email": user.safeEmail
                    ]
                    usersCollection.append(newElement)

                    strongSelf.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }

                        completion(true)
                    })
                }
                else {
                    // create that array
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstname + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                    ]

                    strongSelf.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }

                        completion(true)
                    })
                }
            })
        })
    }
    
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
            database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                guard let value = snapshot.value as? [[String: String]] else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }

                completion(.success(value))
            })
        }
    
    public enum DatabaseError: Error{
        case failedToFetch
    }
    
    
}

/*
       "dfsdfdsfds" {
           "messages": [
               {
                   "id": String,
                   "type": text, photo, video,
                   "content": String,
                   "date": Date(),
                   "sender_email": String,
                   "isRead": true/false,
               }
           ]
       }
          conversaiton => [
             [
                 "conversation_id": "dfsdfdsfds"
                 "other_user_email":
                 "latest_message": => {
                   "date": Date()
                   "latest_message": "message"
                   "is_read": true/false
                 }
             ],
           ]
          */
// Mark : -sending messages conversation
extension DataBaseManager{
    /// Creates a new conversation with target user emamil and first message sent
      public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
      }
    
    /// Fetches and returns all conversations for the user with passed in email
      public func getAllConversations(for email: String, completion: @escaping (Result<String, Error>) -> Void) {
      }
    /// Gets all mmessages for a given conversatino
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result <String, Error>) -> Void) {
    }
    
    /// Sends a message with target conversation and message
    public func sendMessage(to conversation: String, otherUserEmail: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
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
    
    var profilePictureFileName : String {
        //afraz9-gmail-com_profile_picture.png
        
        return "\(safeEmail)_profile_picture.png"
    }
}
