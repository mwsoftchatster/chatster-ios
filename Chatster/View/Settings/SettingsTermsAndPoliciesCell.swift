//
//  SettingsTermsAndPoliciesCell.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 26/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class SettingsTermsAndPoliciesCell: UITableViewCell {

    lazy var termsAndPoliciesBtn: UIButton = {
        let termsAndPoliciesBtn = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Terms & Policies", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        termsAndPoliciesBtn.setTitleColor(.blue, for: .normal)
        termsAndPoliciesBtn.addTarget(self, action: #selector(handleTermsAndPolicies), for: .touchUpInside)
        termsAndPoliciesBtn.setAttributedTitle(attributedTitle, for: .normal)
        
        return termsAndPoliciesBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(termsAndPoliciesBtn)
        termsAndPoliciesBtn.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        termsAndPoliciesBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTermsAndPolicies() {
        print("handleTermsAndPolicies")
    }

}
