//
//  ProfileVC.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 20/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let headerIdentifier = "ProfileHeader"

class ProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, ProfileHeaderDelegate {
    
    var user: User?
    
    var userToLoadFromAnotherVC: User?
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userToLoadFromAnotherVC = self.userToLoadFromAnotherVC {
            self.user = userToLoadFromAnotherVC
        } else {
            // load from local db
            let user = User(userId: "1", userName: "Test User 1", statusMessage: "Hi, I am using Chatster")
            self.user = user
        }
        
        fetchPosts()

        // Register cell classes
        self.collectionView!.register(CreatorPostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)

        self.collectionView?.backgroundColor = .white
        self.navigationItem.title = self.user?.userName
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 168)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.delegate = self
        header.user = self.user
        navigationItem.title = self.user?.userName
        
        return header
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CreatorPostCell
        
        cell.post = posts[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainFeedVC = MainFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        mainFeedVC.viewSinglePost = true
        
        let post = Post(postId: "1", user: self.user!, caption: "test caption", likes: 5, imageUrl: "url here", creatorId: self.user?.userId, creationDate: Date())
        
        mainFeedVC.post = post
        
        navigationController?.pushViewController(mainFeedVC, animated: true)
        
    }
    
    func handleFollowUnfollowTapped(for header: ProfileHeader) {
        print("handleFollowUnfollowTapped")
    }
    
    func handleFollowersTapped(for header: ProfileHeader) {
        let followVC = FollowVC()
        followVC.viewFollowers = true
        
        navigationController?.pushViewController(followVC, animated: true)
    }
    
    func handleFollowingTapped(for header: ProfileHeader) {
        let followVC = FollowVC()
        followVC.viewFollowing = true
        
        navigationController?.pushViewController(followVC, animated: true)
    }
    
    func fetchPosts() {
        let post1 = Post(postId: "1", user: self.user!, caption: "test caption", likes: 5, imageUrl: "url here", creatorId: self.user?.userId, creationDate: Date())
        posts.append(post1)
        
        let post2 = Post(postId: "2", user: self.user!, caption: "test caption 2", likes: 1, imageUrl: "url here", creatorId: self.user?.userId, creationDate: Date())
        posts.append(post2)
        
        let post3 = Post(postId: "3", user: self.user!, caption: "test caption 3", likes: 1, imageUrl: "url here", creatorId: self.user?.userId, creationDate: Date())
        posts.append(post3)
        
        self.collectionView.reloadData()
    }
    
}
