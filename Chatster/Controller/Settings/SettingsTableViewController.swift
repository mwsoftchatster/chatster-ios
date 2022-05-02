//
//  SettingsTableViewController.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 18/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SettingsUserCell"
private let reuseUpdateBtnCell = "SettingsUpdateCell"
private let reusePrivacyPolicyCell = "SettingsPrivacyPolicyCell"
private let reuseTermsAndPoliciesCell = "SettingsTermsAndPoliciesCell"
private let reuseGDPRPrivacyRightsCell = "SettingsGDPRPrivacyRightsCell"

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = User(userId: "1", userName: "Creator 1", statusMessage: "Hi, I am using Chatster")
        self.user = user

        //self.statusMessage.delegate = self
        
        tableView.register(SettingsUserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(SettingsUpdateCell.self, forCellReuseIdentifier: reuseUpdateBtnCell)
        tableView.register(SettingsPrivacyPolicyCell.self, forCellReuseIdentifier: reusePrivacyPolicyCell)
        tableView.register(SettingsTermsAndPoliciesCell.self, forCellReuseIdentifier: reuseTermsAndPoliciesCell)
        tableView.register(SettingsGDPRPrivacyRightsCell.self, forCellReuseIdentifier: reuseGDPRPrivacyRightsCell)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        constructNavigationController()
    }
    
    func constructNavigationController() {
        
        self.navigationItem.title = "Settings"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3"), style: .plain, target: self, action: #selector(navigateToCreatorsSection))
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            return 2
        } else {
            return 3
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionName: String!
        
        if (section == 0) {
            sectionName = "User"
        } else {
            sectionName = "Privacy"
        }
        
        return sectionName
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
               
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsUserCell
                cell.user = self.user
                
                return cell
                
            } else {
                return tableView.dequeueReusableCell(withIdentifier: reuseUpdateBtnCell, for: indexPath) as! SettingsUpdateCell
            }
            
        } else {
            
            if (indexPath.row == 0) {
               return tableView.dequeueReusableCell(withIdentifier: reusePrivacyPolicyCell, for: indexPath) as! SettingsPrivacyPolicyCell
            } else if (indexPath.row == 1) {
                return tableView.dequeueReusableCell(withIdentifier: reuseTermsAndPoliciesCell, for: indexPath) as! SettingsTermsAndPoliciesCell
            } else {
                return tableView.dequeueReusableCell(withIdentifier: reuseGDPRPrivacyRightsCell, for: indexPath) as! SettingsGDPRPrivacyRightsCell
            }
            
        }
        
    }
    
    
    @objc func updateUserProfile() {
        print("updateUserProfile")
    }
    
    @objc func privacyPolicy() {
        print("privacyPolicy")
    }
    
    @objc func termsAndPolicies() {
        print("termsAndPolicies")
    }
    
    @objc func gdprPrivacyRights() {
        print("gdprPrivacyRights")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //print(statusMessage.text!)
        self.view.endEditing(true)
        return false
        
    }
    
    
    @objc func navigateToCreatorsSection() {
        
        let creatorsTabVC = CreatorsTabBarVC()
        self.present(creatorsTabVC, animated: true, completion: nil)
        
    }
    
}
