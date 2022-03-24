//
//  StorageManager.swift
//  Messenger
//
//  Created by Amel Mallem on 3/23/22.
//

import Foundation
import FirebaseStorage
final class StorageManager {
    
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    
    typealias uploadPictureCompletion = ( Result<String , Error>)-> Void
    
    ///Upload picture to firebase storage to download and returns comlition with url string to download
    public func uploadProfilePicture( with data : Data , fileName : String , completion : @ escaping uploadPictureCompletion){
        
        storage.child("images/\(fileName)").putData(data, metadata: nil , completion : { metadata , error in
            guard error == nil else {
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: {url , error in
                guard let url = url else {
                    print ("Failed to get download url")
                    completion(.failure(StorageErrors.faildedToGetDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString 
                print("download url returned : \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public func  DownloadURl(for path : String , completion : @escaping ( Result<URL , Error>) ->Void){
        let refrence = storage.child(path)
        refrence.downloadURL( completion: {url , error in
            guard let url = url , error == nil else {
                
                completion(.failure(StorageErrors.faildedToGetDownloadURL))
                return
            }
            completion(.success(url))
        })
    }
}

public enum StorageErrors : Error {
    
    case failedToUpload
    case faildedToGetDownloadURL
}
