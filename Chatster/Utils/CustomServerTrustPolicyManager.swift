//
//  CustomServerTrustPolicyManager.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 19/05/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class CustomServerTrustPolicyManager: ServerTrustPolicyManager {
    
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        // Check if we have a policy already defined, otherwise just kill the connection
        if let policy = super.serverTrustPolicy(forHost: host) {
            print("*******  policy  ********")
            print(policy)
            print("*******  policy  ********")
            return policy
        } else {
            return .customEvaluation({ (_, _) -> Bool in
                return false
            })
        }
    }
    
}
