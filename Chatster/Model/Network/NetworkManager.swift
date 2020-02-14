/*
  Copyright (C) 2017 - 2020 MWSOFT
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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
