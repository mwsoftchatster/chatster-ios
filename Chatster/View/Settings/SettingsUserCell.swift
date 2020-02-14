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

import UIKit

class SettingsUserCell: UITableViewCell {

    var user: User? {
        
        didSet {
            let name = user?.userName
            userName.text = name
            
            let status = user?.statusMessage
            userStatus.text = status
        }
        
    }
    
    let profileImageView: UIImageView = {
        let piv = UIImageView(image: UIImage(named: "avatarPlaceholder"))
        piv.contentMode = .scaleAspectFill
        piv.backgroundColor = .lightGray
        
        return piv
    }()
    
    let userName: UILabel = {
        let userName = UILabel()
        userName.font = UIFont(name: "Gotham Book", size: 18)
        userName.textAlignment = .left
        
        return userName
    }()
    
    lazy var userStatus: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Status message here..."
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.addTarget(self, action: #selector(statusMessageChanged), for: .editingChanged)
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(userName)
        userName.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 16, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 35)
        
        addSubview(userStatus)
        userStatus.anchor(top: userName.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func statusMessageChanged() {
        print("followUnfollow")
    }

}
