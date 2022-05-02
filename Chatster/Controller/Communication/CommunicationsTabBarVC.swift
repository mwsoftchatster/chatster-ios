//
//  CommunicationsTabBarVC.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 25/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class CommunicationsTabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        configureViewControllers()
        
    }
    
    func configureViewControllers() {
        
        // chats list controller
        let chatListVC = constructNavigationController(unselectedImage: (UIImage(named: "chat") ?? nil)!, selectedImage: (UIImage(named: "chat") ?? nil)!, rootViewController: ChatListTableViewController())
        
        // group chats list controller
        let groupChatListVC = constructNavigationController(unselectedImage: (UIImage(named: "profile_unselected") ?? nil)!, selectedImage: (UIImage(named: "profile_unselected") ?? nil)!, rootViewController: GroupChatListTableViewController())
        
        // contacts list controller
        let contactListVC = constructNavigationController(unselectedImage: (UIImage(named: "profile_unselected") ?? nil)!, selectedImage: (UIImage(named: "profile_selected") ?? nil)!, rootViewController: ContactListTableViewController())
        
        // settings controller
        let settingsVC = constructNavigationController(unselectedImage: (UIImage(named: "settings") ?? nil)!, selectedImage: (UIImage(named: "settings") ?? nil)!, rootViewController: SettingsTableViewController())
        
        // add VCs to tab controller
        viewControllers = [chatListVC, groupChatListVC, contactListVC, settingsVC]
        
        tabBar.tintColor = .black
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    /// construct navigation controllers
    func constructNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        // construct nav controller
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        // return nav controller
        return navController
    }
    
}
