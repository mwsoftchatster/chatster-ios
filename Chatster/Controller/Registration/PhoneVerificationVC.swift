//
//  PhoneVerificationController.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 13/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class PhoneVerificationVC: UIViewController {
    
    var verificationId: String!
    var code: String!
    
    let titleContainerView: UIView = {
        let view = UIView()
        let title = UILabel()
        title.text = "Phone Verification"
        title.font = UIFont(name: "Gotham Book", size: 22)
        view.addSubview(title)
        title.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 220, height: 50)
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }()
    
    let titleDelimeterView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    let desc: UILabel = {
        let description = UILabel()
        description.text = "Please enter your country code and phone number and tap on 'Send'"
        description.font = UIFont(name: "Gotham Book", size: 16)
        description.numberOfLines = 2
        description.textAlignment = .center
        
        return description
    }()
    
    let countryCode: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Code"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.addTarget(self, action: #selector(countryCodeChanged), for: .editingChanged)
        return tf
    }()
    
    let phoneNumber: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Your mobile phone number"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.font = UIFont.systemFont(ofSize: 18)
  
        return tf
    }()
    
    let sendBtn: UIButton = {
        let sendBtn = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Send", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32)])
        sendBtn.setTitleColor(.blue, for: .normal)
        sendBtn.addTarget(self, action: #selector(sendVerificationCode), for: .touchUpInside)
        sendBtn.setAttributedTitle(attributedTitle, for: .normal)
        
        return sendBtn
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(titleContainerView)
        titleContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(titleDelimeterView)
        titleDelimeterView.anchor(top: titleContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        view.addSubview(desc)
        desc.anchor(top: titleDelimeterView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        let stackView = UIStackView(arrangedSubviews: [countryCode, phoneNumber])
        
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillProportionally
        
        view.addSubview(stackView)
        stackView.anchor(top: desc.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
        
        view.addSubview(sendBtn)
        sendBtn.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
    }

    @objc func countryCodeChanged(_ sender: Any) {
        
        if (countryCode.text!.count >= 5) {
            
            countryCode.text = String(countryCode.text!.dropLast())
            
        } else if (countryCode.text! == "+") {
            
            countryCode.text = ""
            
        } else if (countryCode.text!.count == 1) {
            
            countryCode.text = "+" + countryCode.text!
            
        }
        
    }
    
    @objc func sendVerificationCode(_ sender: Any) {
        
        if (countryCode.text!.count >= 2 && phoneNumber.text!.count > 1) {
            
            let phoneNumberToVerify = countryCode.text! + phoneNumber.text!
            
            let alert = UIAlertController(title: "Send Verification Code", message: "Is this your phone number - " + phoneNumberToVerify + "?", preferredStyle: .alert)
            
            let dismiss = UIAlertAction(title: "Edit", style: .cancel, handler: {
                
                (alert: UIAlertAction!) -> Void in
                
            })
            
            let verify = UIAlertAction(title: "Send", style: .default, handler: {
                
                (alert: UIAlertAction!) -> Void in

                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberToVerify, uiDelegate: nil, completion: { (_verificationId, error) in
                    
                    if (error != nil) {
                        
                        ProgressHUD.showError(error!.localizedDescription)
                        return
                        
                    }
                    
                    self.verificationId = _verificationId
                    
                    let codeVerificationVC = CodeVerificationVC()
                    codeVerificationVC.verificationId = self.verificationId
                    self.navigationController?.pushViewController(codeVerificationVC, animated: true)
                    
                })
                
            })
            
            alert.addAction(dismiss)
            alert.addAction(verify)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "All fields are requiered", message: "Please enter both country code and phone number", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: {
                
                (alert: UIAlertAction!) -> Void in
                
            })
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
}
