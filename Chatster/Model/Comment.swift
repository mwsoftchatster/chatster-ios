//
//  Comment.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 23/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation


class Comment {
    
    var commentId: String!
    var commentText: String!
    var creationDate: Date!
    var user: User?
    
    init(user: User, commentId: String!, commentText: String!, creationDate: Date!) {
        
        self.user = user
        
        self.commentId = commentId

        self.commentText = commentText
    
        self.creationDate = creationDate
        
    }
}
