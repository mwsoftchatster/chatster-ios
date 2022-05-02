//
//  FollowingRequest.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 16/06/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class FollowingRequest {
    
    var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func getFollowing(creatorName: String, userId: String, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.CHATSTER_CREATORS_Q_PORT + "/creatorFollows?creatorName=\(creatorName)&userId=\(userId)") { json, error in
            closure(json, error)
        }
    }
    
}
