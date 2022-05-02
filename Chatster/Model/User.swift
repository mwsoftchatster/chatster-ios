//
//  User.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 14/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class User {
    
    var userId: String
    var userName: String
    var statusMessage: String
    
    init(userId: String, userName: String, statusMessage: String) {
        
        self.userId = userId
        self.userName = userName
        self.statusMessage = statusMessage
        
    }
    
}
