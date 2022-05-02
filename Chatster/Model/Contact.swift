//
//  Contact.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 05/05/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class Contact {
    
    var contactId: String
    var contactName: String
    var statusMessage: String
    var isChatsterContact: Bool
    
    init(contactId: String, contactName: String, statusMessage: String, isChatsterContact: Bool) {
        self.contactId = contactId
        self.contactName = contactName
        self.statusMessage = statusMessage
        self.isChatsterContact = isChatsterContact
    }
    
}
