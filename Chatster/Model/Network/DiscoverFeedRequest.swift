//
//  DiscoverFeedRequest.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 30/06/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class DiscoverFeedRequest {
    
    var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func getPosts(userId: Int64, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.CHATSTER_CREATORS_Q_PORT + "/discoverPosts?userId=\(userId)") { json, error in
            closure(json, error)
        }
    }
    
}
