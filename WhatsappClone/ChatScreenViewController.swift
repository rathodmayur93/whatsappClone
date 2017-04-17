//
//  ChatScreenViewController.swift
//  WhatsappClone
//
//  Created by Mayur on 16/04/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatScreenViewController: JSQMessagesViewController {

    //var userRef: FIRDatabaseReference?
    var messages = [JSQMessage]()
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var userRef     = FIRDatabase.database().reference().child(userNameArray[selectedUserIndex].uniqueId)
    var senderRef   = FIRDatabase.database().reference().child(loginUserUniqueId)
    private lazy var messageRef: FIRDatabaseReference = FIRDatabase.database().reference().child("\(userNameArray[selectedUserIndex].uniqueId)/messages")
    private lazy var senderMessageRef : FIRDatabaseReference = FIRDatabase.database().reference().child("\(loginUserUniqueId)/messages")
    
    private var newMessageRefHandle         : FIRDatabaseHandle?
    private var newSenderMessageRefHandle   : FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId           = loginUserName
        self.senderDisplayName  = userFirstName
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        observeMessages()
        print("Selected User id \(userNameArray[selectedUserIndex].uniqueId)")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    /**********  Here you can change bubble background color ************/
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let itemRef = messageRef.childByAutoId() // 1
        let messageItem = [ // 2
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        
        itemRef.setValue(messageItem) // 3
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        
        finishSendingMessage() // 5
    }
    
    private func observeMessages() {
        messageRef          = userRef.child("messages")
        senderMessageRef    = senderRef.child("messages")
        // 1.
        let messageQuery        = messageRef.queryLimited(toLast:25)
        let senderMessageQuery  = senderMessageRef.queryLimited(toLast: 25)
        
        
        newSenderMessageRefHandle = senderMessageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            // 3
            let messageData = snapshot.value as! Dictionary<String, String>
            
            print("Chat with users \(messageData)")
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                
                if(id == userNameArray[selectedUserIndex].userName){
                    self.addMessage(withId: id, name: name, text: text)
                }
                self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
        })
        
        // 2. We can use the observe method to listen for new messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            // 3
            let messageData = snapshot.value as! Dictionary<String, String>
            
            print("Chat with users \(messageData)")
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {

                if(id == loginUserName){
                    self.addMessage(withId: id, name: name, text: text)
                }
                self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
        })
    }
}
