//
//  NetworkManager.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 09/06/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager: NSObject, URLSessionDelegate {
    
    var customSessionDelegate = CustomSessionDelegate()
    var manager: SessionManager?
    
    override init() {
        super.init()
        configureManager()
    }
    
    func configureManager() {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 40
        configuration.timeoutIntervalForResource = 40
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "www.mwsoft.nl": .pinCertificates(
                certificates: ServerTrustPolicy.certificates(),
                validateCertificateChain: false,
                validateHost: false
            )
        ]
        
        self.manager = SessionManager(
            configuration: configuration,
            delegate: customSessionDelegate,
            serverTrustPolicyManager: CustomServerTrustPolicyManager(
                policies: serverTrustPolicies
            )
        )
    }
    
    func loadUrl(url: String, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        let urlObj = URL(string: url)
        
        self.manager?.request(
            urlObj!,
            method: .post,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: SessionManager.defaultHTTPHeaders
        ).responseJSON(
            queue: nil,
            options: JSONSerialization.ReadingOptions.allowFragments
        ) { (response) in
                
            switch response.result {
            case .failure(let error):
                DispatchQueue.main.async {
                    closure(nil, error)
                }
                
            case .success(let data):
                DispatchQueue.main.async {
                    closure(data, nil)
                }
            }

        }
    }
    
    
    
    
    
    
    // self.loadUrl(url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.CHATSTER_CREATORS_Q_PORT + "/creatorFollows?creatorName=nikolaj&userId=31645572649")
    // self.loadUrl(url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.CHATSTER_CREATORS_Q_PORT + "/creatorHistory?creatorName=nikolaj&userId=31645572649")
    
}
