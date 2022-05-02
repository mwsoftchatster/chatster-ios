//
//  Message.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 24/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class Message {
    
    var messageText: String!
    var fromId: String!
    var toId: String!
    var creationDate: Date!
    var imageUrl: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    var videoUrl: String?
    var read: Bool!
    
    init(messageText: String!, fromId: String!, toId: String!, creationDate: Date!, imageUrl: String?, imageHeight: NSNumber?, imageWidth: NSNumber?, videoUrl: String?, read: Bool!) {

        self.messageText = messageText

        self.fromId = fromId
        
        self.toId = toId
        
        self.creationDate = creationDate
        
        self.imageUrl = imageUrl
        
        self.imageHeight = imageHeight
        
        self.imageWidth = imageWidth
        
        self.videoUrl = videoUrl
        
        self.read = read

    }
    
    func getChatPartnerId() -> String {
        return "2"
    }
}
