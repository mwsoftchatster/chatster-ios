//
//  FollowersRequest.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 09/06/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class FollowersRequest {
    
    var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func getFollowers(creatorName: String, userId: String, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.CHATSTER_CREATORS_Q_PORT + "/creatorFollowers?creatorName=\(creatorName)&userId=\(userId)") { json, error in
            closure(json, error)
        }
    }
    
}
