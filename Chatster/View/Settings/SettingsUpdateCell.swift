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
