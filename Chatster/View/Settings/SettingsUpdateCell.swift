//
//  SettingsButtonCell.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 26/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class SettingsUpdateCell: UITableViewCell {
    
    lazy var updateBtn: UIButton = {
        let updateBtn = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "UPDATE", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        updateBtn.setTitleColor(.blue, for: .normal)
        updateBtn.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
        updateBtn.setAttributedTitle(attributedTitle, for: .normal)
        
        return updateBtn
    }()
    
    let delimeterView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(updateBtn)
        updateBtn.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        updateBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(delimeterView)
        delimeterView.anchor(top: updateBtn.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleUpdate() {
        print("handleUpdate")
    }

}
