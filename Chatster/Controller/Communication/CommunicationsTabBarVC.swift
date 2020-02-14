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
