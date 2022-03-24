//
//  ChatViewController.swift
//  Messenger
//
//  Created by Amel Mallem on 3/22/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message : MessageType {
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
   
    
    
}

struct Sender : SenderType{
    
    var photoURL : String
    var senderId: String
    
    var displayName: String
    
    
}

class ChatViewController: MessagesViewController {
    public let  otherUserEmail : String
    public var isNewConversation = false

    public static let dateFormatter: DateFormatter = {
          let formattre = DateFormatter()
          formattre.dateStyle = .medium
          formattre.timeStyle = .long
          formattre.locale = .current
          return formattre
      }()
    
    private var messages = [Message]()
    
    private var selfSender: Sender? {
            guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                return nil
            }
        
        return Sender(photoURL: "",
                              senderId: email,
                              displayName: "Me")
    }
 init(with email :String){
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .red
     
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    

}

extension ChatViewController: InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = self.selfSender,
        let messageId = createMessageId()  else {
            return
        }
        
        
        print("Sending : \(text)")
        let mmessage = Message(sender:selfSender,
                                    messageId: messageId,
                                    sentDate: Date(),
                                    kind: .text(text))
        // create convo in database
        DataBaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: mmessage, completion: { [weak self]success in
            
        })
        //send Message
        if isNewConversation {
            //create convo in database
        }else{
            //append to existing conver
        }
    }
    
    
    
    private func createMessageId() -> String?{
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email")
              else {return nil}
        
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserEmail)_\(currentUserEmail)_\(dateString)"
        //date, otherUserEmail, senderEmail , randomInt
        
        return newIdentifier
        
    }
}

extension ChatViewController : MessagesDataSource , MessagesLayoutDelegate , MessagesDisplayDelegate{
    func currentSender() -> SenderType {
        if let sender = selfSender {
                  return sender
              }

              fatalError("Self Sender is nil, email should be cached")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
