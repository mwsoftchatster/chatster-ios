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
import ProgressHUD
import FirebaseAuth

class CodeVerificationVC: UIViewController {
    
    var verificationId: String!
    
    let barContainerView: UIView = {
        let view = UIView()
        
        let title = UILabel()
        title.text = "Code Verification"
        title.font = UIFont(name: "Gotham Book", size: 22)
        title.textAlignment = .center

        let cancelBtn = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Cancel", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        cancelBtn.setTitleColor(.blue, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelCodeVerification), for: .touchUpInside)
        cancelBtn.setAttributedTitle(attributedTitle, for: .normal)

        let verifyBtn = UIButton(type: .system)
        let _attributedTitle = NSMutableAttributedString(string: "Verify", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        verifyBtn.setTitleColor(.blue, for: .normal)
        verifyBtn.addTarget(self, action: #selector(verifyCode), for: .touchUpInside)
        verifyBtn.setAttributedTitle(_attributedTitle, for: .normal)
        
        let stackView = UIStackView(arrangedSubviews: [cancelBtn, title, verifyBtn])
        
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillProportionally
        
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 70)
        
        return view
    }()
    
    let titleDelimeterView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    let descSMS: UILabel = {
        let description = UILabel()
        description.text = "Within one minute you will receive SMS with verification code."
        description.font = UIFont(name: "Gotham Book", size: 16)
        description.numberOfLines = 2
        description.textAlignment = .center
        
        return description
    }()
    
    let descVerify: UILabel = {
        let description = UILabel()
        description.text = "Please, enter the verification code below and tap on 'Verify'."
        description.font = UIFont(name: "Gotham Book", size: 16)
        description.numberOfLines = 2
        description.textAlignment = .center
        
        return description
    }()
    
    let code: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Verification code here..."
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.font = UIFont.systemFont(ofSize: 18)
        
        return tf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(barContainerView)
        barContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        
        view.addSubview(titleDelimeterView)
        titleDelimeterView.anchor(top: barContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        view.addSubview(descSMS)
        descSMS.anchor(top: titleDelimeterView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(descVerify)
        descVerify.anchor(top: descSMS.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(code)
        code.anchor(top: descVerify.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 150, height: 50)
    }
    
    @objc func cancelCodeVerification(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func verifyCode(_ sender: Any) {
        
        if (code.text != "" && self.verificationId != "") {
            
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationId, verificationCode: code.text!)
            
            Auth.auth().signInAndRetrieveData(with: credential) { authData, error in
                
                if (error != nil) {
                    
                    print(error!.localizedDescription)
                    ProgressHUD.showError("The verification code is incorrect!")
                    return
                    
                }
                
                let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "communicationSection") as! UITabBarController
                
                self.present(mainView, animated: true, completion: nil)
                
            };
            
        } else {
            
            ProgressHUD.showError("The verification code is incorrect!")
            
        }
 
    }
}
