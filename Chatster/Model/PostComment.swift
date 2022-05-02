//
//  PostComment.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 23/06/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class PostComment {
    
    var _id: Int64
    var postUUID: String
    var creatorsName: String
    var userProfilePicUrl: String
    var comment: String
    var commentCreated: String
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json: [String: Any]) throws {
        
        // Extract _id
        guard let _id = json["_id"] as? Int64 else {
            throw SerializationError.missing("_id")
        }
        
        // Extract postUUID
        guard let postUUID = json["postUUID"] as? String else {
            throw SerializationError.missing("postUUID")
        }
        
        // Extract creatorsName
        guard let creatorsName = json["creatorsName"] as? String else {
            throw SerializationError.missing("creatorsName")
        }
        
        // Extract userProfilePicUrl
        guard let userProfilePicUrl = json["userProfilePicUrl"] as? String else {
            throw SerializationError.missing("userProfilePicUrl")
        }
        
        // Extract comment
        guard let comment = json["comment"] as? String else {
            throw SerializationError.missing("comment")
        }
        
        // Extract commentCreated
        guard let commentCreated = json["commentCreated"] as? String else {
            throw SerializationError.missing("commentCreated")
        }
        
        // Initialize properties
        self._id = _id
        self.postUUID = postUUID
        self.creatorsName = creatorsName
        self.userProfilePicUrl = userProfilePicUrl
        self.comment = comment
        self.commentCreated = commentCreated
        
    }
    
}
