//
//  ChatListTableViewCell.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 14/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {
    
    var chat: Chat? {
        
        didSet {
            let name = chat?.contactName
            contactName.text = name
            
            let lastMsg = chat?.lastMessage
            lastMessage.text = lastMsg
            
            let lastMsgDate = chat?.lastMessageDate
            lastMessageDate.text = lastMsgDate
        }
        
    }
    
    let chatImageView: UIImageView = {
        let piv = UIImageView(image: UIImage(named: "avatarPlaceholder"))
        piv.contentMode = .scaleAspectFill
        piv.backgroundColor = .lightGray
        
        return piv
    }()
    
    let contactName: UILabel = {
        let contactName = UILabel()
        contactName.font = UIFont(name: "Gotham Book", size: 18)
        contactName.textAlignment = .left
        
        return contactName
    }()
    
    let lastMessageDate: UILabel = {
        let lastMessageDate = UILabel()
        lastMessageDate.font = UIFont(name: "Gotham Book", size: 18)
        lastMessageDate.textAlignment = .left
        
        return lastMessageDate
    }()
    
    let lastMessage: UILabel = {
        let lastMessage = UILabel()
        lastMessage.font = UIFont(name: "Gotham Book", size: 18)
        lastMessage.textAlignment = .left
        
        return lastMessage
    }()
    
    let unreadMessagesBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        
        let unreadMessagesCounter = UILabel()
        unreadMessagesCounter.font = UIFont(name: "Gotham Book", size: 12)
        unreadMessagesCounter.textAlignment = .center
        unreadMessagesCounter.text = "100"
        unreadMessagesCounter.textColor = .white
        
        view.addSubview(unreadMessagesCounter)
        unreadMessagesCounter.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(chatImageView)
        chatImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        chatImageView.layer.cornerRadius = 80 / 2
        chatImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(contactName)
        contactName.anchor(top: self.topAnchor, left: chatImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 35)
        
        addSubview(lastMessageDate)
        lastMessageDate.anchor(top: self.topAnchor, left: contactName.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 16, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 35)
        
        addSubview(lastMessage)
        lastMessage.anchor(top: contactName.bottomAnchor, left: chatImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
        
        addSubview(unreadMessagesBackground)
        unreadMessagesBackground.anchor(top: lastMessageDate.bottomAnchor, left: lastMessage.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 35, height: 35)
        unreadMessagesBackground.layer.cornerRadius = 35 / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
