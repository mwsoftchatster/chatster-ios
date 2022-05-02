//
//  ReceivedOnlineGroupMessage.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 05/05/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class ReceivedOnlineGroupMessage {
    
    var id: Int64
    var messageUUID: String
    
    init(id: Int64, messageUUID: String, groupChatId: String) {
        
        self.id = id
        self.messageUUID = messageUUID
        
    }
    
}
