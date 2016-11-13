//
//  ChatViewController.swift
//  cnnct
//
//  Created by Michael Umenta on 11/13/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
import Photos

class ChatViewController: JSQMessagesViewController {
    
    var channelRef: FIRDatabaseReference?
    var displayName: String!
    var sendeeDisplayName: String!
    var userID: String!
    var messages = [JSQMessage]()
    
    lazy var storageRef: FIRStorageReference = FIRStorage.storage().reference(forURL: "gs://cnnct-f6007.appspot.com")
    private let imageURLNotSetKey = "NOTSET"
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    private lazy var messageRef: FIRDatabaseReference = self.channelRef!.child("messages")
    private var newMessageRefHandle: FIRDatabaseHandle?
    
    private lazy var userIsTypingRef: FIRDatabaseReference =
        self.channelRef!.child("typingIndicator").child(self.senderId) // 1
    private var localTyping = false // 2
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            // 3
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }


    private lazy var usersTypingQuery: FIRDatabaseQuery =
        self.channelRef!.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
//    var channel: Channel? {
//        didSet {
//            title = channel?.name
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeMessages()
        // Do any additional setup after loading the view, typically from a nib.
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 2.0/255.0, green: 208.0/255.0, blue: 172.0/255.0, alpha: 1.0),NSFontAttributeName:UIFont.systemFont(ofSize: 25, weight: UIFontWeightLight)]
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.senderId = userID
        self.senderDisplayName = displayName
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.topItem?.title = sendeeDisplayName
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        observeTyping()
    }
    
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
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    private func observeMessages() {
        messageRef = channelRef!.child("messages")
        // 1.
        let messageQuery = messageRef.queryLimited(toLast:25)
        
        // 2. We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            // 3
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                // 4
                self.addMessage(withId: id, name: name, text: text)
                
                // 5
                self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
        })
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        //isTyping = textView.text != ""
        isTyping = false
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = messageRef.childByAutoId() // 1
        let messageItem = [ // 2
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        
        itemRef.setValue(messageItem) // 3
        channelRef?.updateChildValues(["lastMessage": text!])
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        
        finishSendingMessage() // 5
        isTyping = false
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    private func observeTyping() {
        let typingIndicatorRef = channelRef!.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        
        // 1
        usersTypingQuery.observe(.value) { (data: FIRDataSnapshot) in
            // 2 You're the only one typing, don't show the indicator
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            
            // 3 Are there others typing?
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottom(animated: true)
        }
    }
    
    func sendPhotoMessage() -> String? {
        let itemRef = messageRef.childByAutoId()
        
        let messageItem = [
            "photoURL": imageURLNotSetKey,
            "senderId": senderId!,
            ]
        
        itemRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
        return itemRef.key
    }
    
    func setImageURL(_ url: String, forPhotoMessageWithKey key: String) {
        let itemRef = messageRef.child(key)
        itemRef.updateChildValues(["photoURL": url])
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
//            picker.sourceType = UIImagePickerControllerSourceType.camera
//        } else {
//            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        }
//        
//        present(picker, animated: true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: Image Picker Delegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion:nil)
        
        // 1
        if let photoReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
            // Handle picking a Photo from the Photo Library
            // 2
            let assets = PHAsset.fetchAssets(withALAssetURLs: [photoReferenceUrl], options: nil)
            let asset = assets.firstObject
            
            // 3
            if let key = sendPhotoMessage() {
                // 4
                asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
                    let imageFileURL = contentEditingInput?.fullSizeImageURL
                    
                    // 5
                    let path = "\(FIRAuth.auth()?.currentUser?.uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\(photoReferenceUrl.lastPathComponent)"
                    
                    // 6
                    self.storageRef.child(path).putFile(imageFileURL!, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print("Error uploading photo: \(error.localizedDescription)")
                            return
                        }
                        // 7
                        self.setImageURL(self.storageRef.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
                    }
                })
            }
        } else {
            // Handle picking a Photo from the Camera - TODO
            // 1
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            // 2
            if let key = sendPhotoMessage() {
                // 3
                let imageData = UIImageJPEGRepresentation(image, 1.0)
                // 4
                let imagePath = FIRAuth.auth()!.currentUser!.uid + "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
                // 5
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                // 6
                storageRef.child(imagePath).put(imageData!, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        print("Error uploading photo: \(error)")
                        return
                    }
                    // 7
                    self.setImageURL(self.storageRef.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
}


