//
//  CreatorsTabBarVC.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 20/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class CreatorsTabBarVC: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        configureViewControllers()
        
    }
    
    func configureViewControllers() {
    
        // main feed controller
        let mainFeedVC = constructNavigationController(unselectedImage: (UIImage(named: "home_unselected") ?? nil)!, selectedImage: (UIImage(named: "home_selected") ?? nil)!, rootViewController: MainFeedVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // create new post controller
//        let createPostVC = constructNavigationController(unselectedImage: (UIImage(named: "plus_unselected") ?? nil)!, selectedImage: (UIImage(named: "plus_unselected") ?? nil)!, rootViewController: CreatePostVC())
        let selectPhotoVC = constructNavigationController(unselectedImage: (UIImage(named: "plus_unselected") ?? nil)!, selectedImage: (UIImage(named: "plus_unselected") ?? nil)!)
        
        // discover controller
        let dicoverVC = constructNavigationController(unselectedImage: (UIImage(named: "search_unselected") ?? nil)!, selectedImage: (UIImage(named: "search_selected") ?? nil)!, rootViewController: DiscoverVC())
        
        // history controller
        let historyVC = constructNavigationController(unselectedImage: (UIImage(named: "like_unselected") ?? nil)!, selectedImage: (UIImage(named: "like_selected") ?? nil)!, rootViewController: HistoryVC())
        
        // profile controller
        let profileVC = constructNavigationController(unselectedImage: (UIImage(named: "profile_unselected") ?? nil)!, selectedImage: (UIImage(named: "profile_unselected") ?? nil)!, rootViewController: ProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // add VCs to tab controller
        viewControllers = [mainFeedVC, selectPhotoVC, dicoverVC, historyVC, profileVC]
        
        tabBar.tintColor = .black
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        
        if index == 1 {
            
            let selectImageVC = SelectImageVC(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: selectImageVC)
            navController.navigationBar.tintColor = .black
            
            present(navController, animated: true, completion: nil)
            
            return false
            
        }
        
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
