//
//  CreatorPost.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 23/06/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class CreatorPost {
    
    var uuid: String!
    var creatorProfilePicUrl: String!
    var creatorsName: String!
    var postUrls: [String]?
    var postCaption: String!
    var hasBeenLiked = false
    var likes: Int64!
    var comments: Int64!
    var postCreated: String!
    var followingThisCreator: Int64!
    var postText: String?
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json: [String: Any]) throws {
        
        // Extract uuid
        guard let uuid = json["uuid"] as? String else {
            throw SerializationError.missing("uuid")
        }
        
        // Extract creatorProfilePicUrl
        guard let creatorProfilePicUrl = json["creatorProfilePicUrl"] as? String else {
            throw SerializationError.missing("creatorProfilePicUrl")
        }
        
        // Extract creatorsName
        guard let creatorsName = json["creatorsName"] as? String else {
            throw SerializationError.missing("creatorsName")
        }
        
        // Extract postUrls
        let postUrls = ((json["postUrls"] as? [String]) != nil) ? json["postUrls"] as? [String] : [""]
        
        // Extract postCaption
        guard let postCaption = json["postCaption"] as? String else {
            throw SerializationError.missing("postCaption")
        }
        
        // Extract hasBeenLiked
        let hasBeenLiked = false
        
        // Extract likes
        guard let likes = json["likes"] as? Int64 else {
            throw SerializationError.missing("likes")
        }
        
        // Extract comments
        guard let comments = json["comments"] as? Int64 else {
            throw SerializationError.missing("comments")
        }
        
        // Extract postCreated
        guard let postCreated = json["postCreated"] as? String else {
            throw SerializationError.missing("postCreated")
        }
        
        // Extract followingThisCreator
        guard let followingThisCreator = json["followingThisCreator"] as? Int64 else {
            throw SerializationError.missing("followingThisCreator")
        }
        
        // Extract postText
        let postText = ((json["postText"] as? String) != nil) ? json["postText"] as? String : ""
        
        
        // Initialize properties
        self.uuid = uuid
        self.creatorProfilePicUrl = creatorProfilePicUrl
        self.creatorsName = creatorsName
        self.postUrls = postUrls
        self.postCaption = postCaption
        self.hasBeenLiked = hasBeenLiked
        self.likes = likes
        self.comments = comments
        self.postCreated = postCreated
        self.followingThisCreator = followingThisCreator
        self.postText = postText
        
    }
    
    
}
