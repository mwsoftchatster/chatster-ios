//
//  Extensions.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 19/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import Foundation
import CommonCrypto

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIButton {
    
    func configure(didFollow: Bool) {
        
        if didFollow {
            
            // handle follow user
            self.setTitle("Following", for: .normal)
            self.setTitleColor(.black, for: .normal)
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.backgroundColor = .white
            
        } else {
            
            // handle unfollow user
            self.setTitle("Follow", for: .normal)
            self.setTitleColor(.white, for: .normal)
            self.layer.borderWidth = 0
            self.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        }
    }
}

extension Date {
    
    func timeAgoToDisplay() -> String {
        
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "SECOND"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "MIN"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "HOUR"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "DAY"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "WEEK"
        } else {
            quotient = secondsAgo / month
            unit = "MONTH"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "S") AGO"
    }
    
}

extension Data {
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

extension String {
    func hmacBytes(key: String) -> Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), key, key.count, self, self.count, &digest)
        
        let data = Data(bytes: digest)
        
        return data
    }
}
