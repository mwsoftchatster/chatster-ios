//
//  File.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 24/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class HistoryItem {
    
    enum HistoryItemType: Int, Printable {
        
        case Like
        case Comment
        case Follow
        case CommentMention
        case PostMention
        
        var description: String {
            switch self {
            case .Like: return " liked your post"
            case .Comment: return " commented on your post"
            case .Follow: return " started following you"
            case .CommentMention: return " mentioned you in a comment"
            case .PostMention: return " mentioned you in a post"
            }
        }
        
        init(index: Int) {
            switch index {
            case 0: self = .Like
            case 1: self = .Comment
            case 2: self = .Follow
            case 3: self = .CommentMention
            case 4: self = .PostMention
            default: self = .Like
            }
        }
    }
    
    var creationDate: Date!
    var userId: String!
    var postId: String?
    var post: Post?
    var user: User!
    var type: Int?
    var historyItemType: HistoryItemType!
    var commentId: String?
    var commentText: String?
    var didCheck = false
    
    init(user: User, post: Post? = nil, userId: String!, postId: String?, type: Int?, historyItemType: Int!, commentId: String?, commentText: String?, creationDate: Date!, checked: Bool!) {
        
        self.user = user
        
        if let post = post {
            self.post = post
        }
        
        self.creationDate = creationDate
        
        self.historyItemType = HistoryItemType(index: historyItemType)
        
        self.userId = userId

        self.postId = postId

        self.commentId = commentId

        self.didCheck = checked

    }
}
