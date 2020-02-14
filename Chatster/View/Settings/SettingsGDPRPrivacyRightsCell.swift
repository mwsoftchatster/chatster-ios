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
