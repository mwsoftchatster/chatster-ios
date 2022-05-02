//
//  Creator.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 30/06/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class Creator {
    
    var creatorId: String
    var statusMessage: String
    var profilePic: String
    var posts: Int64
    var creatorFollowers: Int64
    var creatorFollowing: Int64
    var creatorProfileViews: Int64
    var creatorTotalLikes: Int64
    var website: String
    var followingThisCreator: Int64
    var creatorPosts: [CreatorPost]?
    
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json: [String: Any]) throws {
        
        // Extract creatorFollowers
        guard let creatorFollowers = json["creatorFollowers"] as? Int64 else {
            throw SerializationError.missing("creatorFollowers")
        }
        
        // Extract creatorFollowing
        guard let creatorFollowing = json["creatorFollowing"] as? Int64 else {
            throw SerializationError.missing("creatorFollowing")
        }
        
        // Extract creatorId
        guard let creatorId = json["creatorId"] as? String else {
            throw SerializationError.missing("creatorId")
        }
        
        // Extract creatorProfileViews
        guard let creatorProfileViews = json["creatorProfileViews"] as? Int64 else {
            throw SerializationError.missing("creatorProfileViews")
        }
        
        // Extract creatorTotalLikes
        guard let creatorTotalLikes = json["creatorTotalLikes"] as? Int64 else {
            throw SerializationError.missing("creatorTotalLikes")
        }
        
        // Extract followingThisCreator
        guard let followingThisCreator = json["followingThisCreator"] as? Int64 else {
            throw SerializationError.missing("followingThisCreator")
        }
        
        // Extract posts
        guard let posts = json["posts"] as? Int64 else {
            throw SerializationError.missing("posts")
        }
        
        // Extract profilePic
        guard let profilePic = json["profilePic"] as? String else {
            throw SerializationError.missing("profilePic")
        }
        
        // Extract statusMessage
        guard let statusMessage = json["statusMessage"] as? String else {
            throw SerializationError.missing("statusMessage")
        }
        
        // Extract website
        guard let website = json["website"] as? String else {
            throw SerializationError.missing("website")
        }
        
        // Extract creatorPosts
        guard let psts = json["creatorPosts"] as? [[String : Any]] else {
            throw SerializationError.missing("creatorPosts")
        }
        
        for post in psts {
            let creatorPost = try CreatorPost(json: post)
            self.creatorPosts?.append(creatorPost)
        }
        
        // Initialize properties
        self.creatorFollowers = creatorFollowers
        self.creatorFollowing = creatorFollowing
        self.creatorId = creatorId
        self.creatorProfileViews = creatorProfileViews
        self.creatorTotalLikes = creatorTotalLikes
        self.followingThisCreator = followingThisCreator
        self.posts = posts
        self.profilePic = profilePic
        self.statusMessage = statusMessage
        self.website = website
        
    }
    
    
}
