//
//  HistoryRequest.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 23/06/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class HistoryRequest {
    
    var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func getHistory(creatorName: String, userId: String, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.CHATSTER_CREATORS_Q_PORT + "/creatorHistory?creatorName=\(creatorName)&userId=\(userId)") { json, error in
            closure(json, error)
        }
    }
    
}
