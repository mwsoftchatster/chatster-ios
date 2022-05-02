//
//  ChatViewController.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 16/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import IDMPhotoBrowser
import AVFoundation
import AVKit

class ChatViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var outgoingBubble = JSQMessagesBubbleImageFactory()?.outgoingMessagesBubbleImage(with: UIColor.init(red: 0.0, green: 191.0, blue: 255.0, alpha: 1.0))
    var incommingBubble = JSQMessagesBubbleImageFactory()?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    
    var messages: [JSQMessage] = []
    
    let leftBarButtonView: UIView = {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        return view
        
    }()
    
    let contactProfilePicButton: UIButton = {
        
        let btn = UIButton(frame: CGRect(x: 0, y: 10, width: 25, height: 25))
        return btn
        
    }()
    
    let contactName: UILabel = {
        
        let contactName = UILabel(frame: CGRect(x: 30, y: 10, width: 140, height: 15))
        contactName.textAlignment = .left
        contactName.font = UIFont(name: "Gotham Book", size: 14)
        
        return contactName
        
    }()
    
    let contactStatus: UILabel = {
        
        let contactStatus = UILabel(frame: CGRect(x: 30, y: 25, width: 140, height: 15))
        contactStatus.textAlignment = .left
        contactStatus.font = UIFont(name: "Gotham Book", size: 10)
        
        return contactStatus
        
    }()

    // fix for iPhone X
    override func viewDidLayoutSubviews() {
        
        perform(Selector("jsq_updateCollectionViewInsets"))
        
    }
    // end of fix for iPhone X
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem.init(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(self.backAction))]
        
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        setCustomTitle()
        
        // fix for iPhone X
        let constraint =  perform(Selector("toolbarBottomLayoutGuide"))?.takeUnretainedValue() as! NSLayoutConstraint
        
        constraint.priority = UILayoutPriority(rawValue: 1000)
        
        self.inputToolbar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        // end of fix for iPhone X
        
        self.inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "mic"), for: .normal)
        self.inputToolbar.contentView.rightBarButtonItem.setTitle("", for: .normal)
        
        let message1 = JSQMessage(senderId: "123456789", displayName: "Test", text: "Just a test message 1")
        let message2 = JSQMessage(senderId: "987654321", displayName: "Test2", text: "Just a test message 2")
        let message3 = JSQMessage(senderId: "123456789", displayName: "Test", text: "Just a test message 3")
        let message4 = JSQMessage(senderId: "987654321", displayName: "Test2", text: "Just a test message 4")
        
        messages.append(message1!)
        messages.append(message2!)
        messages.append(message3!)
        messages.append(message4!)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        if indexPath.row % 2 == 0 {
            cell.textView?.textColor = .white
        } else {
            cell.textView?.textColor = .black
        }
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        return messages[indexPath.row]
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        if indexPath.row % 2 == 0 {
            return incommingBubble
        } else {
            return outgoingBubble
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        if indexPath.row % 2 == 0 {
            
            let message = messages[indexPath.row]
            return JSQMessagesTimestampFormatter.shared()?.attributedTimestamp(for: message.date)
            
        }
        
        return nil
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        
        if indexPath.row % 2 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let message = messages[indexPath.row]
        
        let senderName: NSAttributedString!
        
        let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor.darkGray]
        
        senderName = NSAttributedString(string: message.senderDisplayName, attributes: attributedStringColor)
        
        return senderName
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
        let message = messages[indexPath.row]
        
        let mediaItem = message.media as! JSQPhotoMediaItem
        
        let photos = IDMPhoto.photos(withImages: [mediaItem.image])
        
        let browser = IDMPhotoBrowser.init(photos: photos)
        
        self.present(browser!, animated: true, completion: nil)
        
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        let camera = Camera(delegate_: self)
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takeNewPhotoOrVideo = UIAlertAction(title: "Camera", style: .default) { (action) in
            camera.PresentPhotoCamera(target: self, canEdit: false)
        }
        
        let chooseExistingPhoto = UIAlertAction(title: "Choose Photo", style: .default) { (action) in
            camera.PresentPhotoLibrary(target: self, canEdit: false)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        takeNewPhotoOrVideo.setValue(UIImage(named: "camera"), forKey: "image")
        chooseExistingPhoto.setValue(UIImage(named: "picture"), forKey: "image")
        
        optionMenu.addAction(takeNewPhotoOrVideo)
        optionMenu.addAction(chooseExistingPhoto)
        optionMenu.addAction(cancel)
        
        if ( UI_USER_INTERFACE_IDIOM() == .pad ) {
            
            if let currentPopoverpresentioncontroller = optionMenu.popoverPresentationController {
                
                currentPopoverpresentioncontroller.sourceView = self.inputToolbar.contentView.leftBarButtonItem
                currentPopoverpresentioncontroller.sourceRect = self.inputToolbar.contentView.bounds
                
                currentPopoverpresentioncontroller.permittedArrowDirections = .up
                self.present(optionMenu, animated: true, completion: nil)
                
            }
            
        } else {
            
            self.present(optionMenu, animated: true, completion: nil)
            
        }
        
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        if text != "" {
            
            JSQSystemSoundPlayer.jsq_playMessageSentAlert()
            self.sendMessage(text: text, date: date, image: nil, location: nil, video: nil, audio: nil)
            
            updateSendButton(isSend: false)
            
        } else {
            
            print("audio")
            
        }
        
    }
    
    @objc func backAction() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        
        if textView.text != "" {
            
            updateSendButton(isSend: true)
            
        } else {
            
            updateSendButton(isSend: false)
            
        }
        
    }
    
    func updateSendButton(isSend: Bool) {
        
        if isSend {
            
            self.inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "send"), for: .normal)
            
        } else {
            
            self.inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "mic"), for: .normal)
            
        }
        
    }
    
    func sendMessage(text: String, date: Date, image: UIImage?, location: String?, video: NSURL?, audio: String?) {
        
        let id : String
        let name : String
        
        let isOutgoing : Bool
        
        if messages.count % 2 == 0 {
            
            id = "123456789"
            name = "Test1"
            
            isOutgoing = true
            
        } else {
            
            id = "987654321"
            name = "Test2"
            
            isOutgoing = false
            
        }
        
        if text != "" {
            
            let message = JSQMessage(senderId: id, displayName: name, text: text)
            messages.append(message!)
            
        }
        
        if image != nil {
            
            let mediaItem = PhotoMediaItem(image: image)
            mediaItem?.appliesMediaViewMaskAsOutgoing = isOutgoing
            self.collectionView.reloadData()
            
            let message = JSQMessage(senderId: id, senderDisplayName: name, date: date, media: mediaItem)
            messages.append(message!)
            
            JSQSystemSoundPlayer.jsq_playMessageSentAlert()
            
        }
        
        
        self.finishSendingMessage()
        
        
    }
    
    func setCustomTitle() {
        
        leftBarButtonView.addSubview(contactProfilePicButton)
        leftBarButtonView.addSubview(contactName)
        leftBarButtonView.addSubview(contactStatus)
        
        let infoButton = UIBarButtonItem(image: UIImage(named: "info"), style: .plain, target: self, action: #selector(self.infoButtonPressed))
        self.navigationItem.rightBarButtonItem = infoButton
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonView)
        self.navigationItem.leftBarButtonItems?.append(leftBarButtonItem)
        
        contactProfilePicButton.setImage(UIImage(named: "info"), for: .normal)
        
        contactName.text = "Test Contact"
        contactStatus.text = "Online"
        
    }
    
    @objc func infoButtonPressed() {
        
        let chatInfoVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chatInfo") as! ChatInfoTableViewController
        
        self.navigationController?.pushViewController(chatInfoVC, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let video = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
        let picture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        self.sendMessage(text: "", date: Date(), image: picture, location: nil, video: video, audio: nil)
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
