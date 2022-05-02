//
//  Post.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 22/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class Post {
    
    var caption: String!
    var likes: Int!
    var imageUrl: String!
    var creatorId: String!
    var creationDate: Date!
    var postId: String!
    var user: User?
    var didLike = false
    
    init(postId: String!, user: User, caption: String!, likes: Int!, imageUrl: String!, creatorId: String!, creationDate: Date!) {
        
        self.postId = postId
        
        self.user = user
        
        if let caption = caption {
            self.caption = caption
        }
        
        if let likes = likes {
            self.likes = likes
        }
        
        if let imageUrl = imageUrl {
            self.imageUrl = imageUrl
        }
        
        if let creatorId = creatorId {
            self.creatorId = creatorId
        }
        
        if let creationDate = creationDate {
            self.creationDate = creationDate
        }
    }

}
