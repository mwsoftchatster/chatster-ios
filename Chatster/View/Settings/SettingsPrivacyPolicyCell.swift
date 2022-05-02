//
//  SettingsPrivacyPolicyCell.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 26/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class SettingsPrivacyPolicyCell: UITableViewCell {

    lazy var privacyPolicyBtn: UIButton = {
        let privacyPolicyBtn = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Privacy Policy", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        privacyPolicyBtn.setTitleColor(.blue, for: .normal)
        privacyPolicyBtn.addTarget(self, action: #selector(handlePrivacyPolicy), for: .touchUpInside)
        privacyPolicyBtn.setAttributedTitle(attributedTitle, for: .normal)
        
        return privacyPolicyBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(privacyPolicyBtn)
        privacyPolicyBtn.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        privacyPolicyBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePrivacyPolicy() {
        print("handlePrivacyPolicy")
    }

}
