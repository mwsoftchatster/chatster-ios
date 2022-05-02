//
//  SettingsGDPRPrivacyRightsCell.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 26/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class SettingsGDPRPrivacyRightsCell: UITableViewCell {

    lazy var gdprPrivacyRightsBtn: UIButton = {
        let gdprPrivacyRightsBtn = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "GDPR Privacy Rights", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        gdprPrivacyRightsBtn.setTitleColor(.blue, for: .normal)
        gdprPrivacyRightsBtn.addTarget(self, action: #selector(handleGDPRPrivacyRightsBtn), for: .touchUpInside)
        gdprPrivacyRightsBtn.setAttributedTitle(attributedTitle, for: .normal)
        
        return gdprPrivacyRightsBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(gdprPrivacyRightsBtn)
        gdprPrivacyRightsBtn.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        gdprPrivacyRightsBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleGDPRPrivacyRightsBtn() {
        print("handleGDPRPrivacyRightsBtn")
    }

}
