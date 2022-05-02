//
//  PostCommentsRequest.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 23/06/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class PostCommentsRequest {
    
    var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func getPostComments(postUUID: String, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.CHATSTER_CREATORS_Q_PORT + "/creatorPostComments?postUUID=\(postUUID)") { json, error in
            closure(json, error)
        }
    }
    
}
