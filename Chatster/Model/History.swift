//
//  History.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 23/06/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class History {
    
    var userProfilePic: String
    var userName: String
    var type: String
    var description: String
    var created: String
    var postUUID: String
    var postUrl: String
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json: [String: Any]) throws {
        
        // Extract userProfilePic
        guard let userProfilePic = json["userProfilePic"] as? String else {
            throw SerializationError.missing("userProfilePic")
        }
        
        // Extract userName
        guard let userName = json["userName"] as? String else {
            throw SerializationError.missing("userName")
        }
        
        // Extract type
        guard let type = json["type"] as? String else {
            throw SerializationError.missing("type")
        }
        
        // Extract description
        guard let description = json["description"] as? String else {
            throw SerializationError.missing("description")
        }
        
        // Extract created
        guard let created = json["created"] as? String else {
            throw SerializationError.missing("created")
        }
        
        // Extract postUUID
        let postUUID = ((json["postUUID"] as? String) != nil) ? json["postUUID"] as? String : ""
        
        // Extract postUrl
        let postUrl = ((json["postUrl"] as? String) != nil) ? json["postUrl"] as? String : ""
        
        // Initialize properties
        self.userProfilePic = userProfilePic
        self.userName = userName
        self.type = type
        self.description = description
        self.created = created
        self.postUUID = postUUID!
        self.postUrl = postUrl!
        
    }
    
}
