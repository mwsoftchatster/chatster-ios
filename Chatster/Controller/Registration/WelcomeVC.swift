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

class WelcomeVC: UIViewController {
    
    let logoContainerView: UIView = {
        let view = UIView()
        let logo = UIImageView(image: UIImage(named: "chatster_logo"))
        logo.contentMode = .scaleAspectFill
        view.addSubview(logo)
        logo.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 125, height: 125)
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }()
    
    let welcome: UILabel = {
        let welcome = UILabel()
        welcome.text = "Welcome to Chatster"
        welcome.font = UIFont(name: "Gotham Book", size: 28)
        welcome.textAlignment = .center
        
        return welcome
    }()
    
    let termsAndPoliciesLb: UILabel = {
        let termsAndPolicies = UILabel()
        termsAndPolicies.text = "By tapping on 'Accept & Next' you agree to our"
        termsAndPolicies.font = UIFont(name: "Gotham Book", size: 14)
        termsAndPolicies.textAlignment = .center
        
        return termsAndPolicies
    }()
    
    let termsAndPoliciesBtn: UIButton = {
        let termsAndPoliciesBtn = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Terms & Policies", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        termsAndPoliciesBtn.setTitleColor(.blue, for: .normal)
        termsAndPoliciesBtn.addTarget(self, action: #selector(termsAndPolicies), for: .touchUpInside)
        termsAndPoliciesBtn.setAttributedTitle(attributedTitle, for: .normal)
        
        return termsAndPoliciesBtn
    }()
    
    let acceptAndNextBtn: UIButton = {
        let acceptAndNextBtn = UIButton(type: .system)
        acceptAndNextBtn.setTitleColor(.blue, for: .normal)
        
        let attributedTitle = NSMutableAttributedString(string: "Accept & Next", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32)])
        acceptAndNextBtn.addTarget(self, action: #selector(acceptAndNext), for: .touchUpInside)
        acceptAndNextBtn.setAttributedTitle(attributedTitle, for: .normal)
        
        return acceptAndNextBtn
    }()
    
    let copyright: UILabel = {
        let copyright = UILabel()
        copyright.text = "Copyright 2017 - 2019 MWSOFT"
        copyright.font = UIFont(name: "Gotham Book", size: 14)
        copyright.textAlignment = .center
        
        return copyright
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        view.addSubview(welcome)
        welcome.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        view.addSubview(termsAndPoliciesLb)
        termsAndPoliciesLb.anchor(top: welcome.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        
        view.addSubview(termsAndPoliciesBtn)
        termsAndPoliciesBtn.anchor(top: termsAndPoliciesLb.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        view.addSubview(acceptAndNextBtn)
        acceptAndNextBtn.anchor(top: termsAndPoliciesBtn.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        view.addSubview(copyright)
        copyright.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
    }
    
    @objc func termsAndPolicies() {
    }
    
    @objc func acceptAndNext() {
        
        let alert = UIAlertController(title: "To use Chatster you must be at least 16 years old", message: "Are you at least 16 years old?", preferredStyle: .alert)
        
        let dismiss = UIAlertAction(title: "No", style: .cancel, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
        })
        
        let verify = UIAlertAction(title: "Yes", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
            let phoneVerificationVC = PhoneVerificationVC()
            self.navigationController?.pushViewController(phoneVerificationVC, animated: true)
            
        })
        
        alert.addAction(dismiss)
        alert.addAction(verify)
        
        self.present(alert, animated: true, completion: nil)
        
    }

}
