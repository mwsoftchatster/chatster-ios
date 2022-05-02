//
//  MainFeedVC.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 20/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainFeedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, MainFeedCellDelegate {
    
    var posts: [Post] = []
    var post: Post?
    var user: User?
    var viewSinglePost = false
    
    var messageNotificationView: MessageNotificationView = {
        let view = MessageNotificationView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        // Register cell classes
        self.collectionView!.register(MainFeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // configure refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl

        configureNavigationBar()
        
        // load from local db
        let user = User(userId: "1", userName: "Test User 1", statusMessage: "Hi, I am using Chatster")
        self.user = user
        
        // fetch posts
        if !viewSinglePost {
            fetchPosts()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewSinglePost {
            return 1
        } else {
            return posts.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainFeedCell
        cell.delegate = self
        
        if viewSinglePost {
            if let post = self.post {
                cell.post = post
            }
        } else {
            cell.post = posts[indexPath.item]
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if posts.count > 4 {
            if indexPath.item == posts.count - 1 {
                // fetchPosts()
            }
        }
    }
    
    func configureNavigationBar() {
        
        if !viewSinglePost {
            self.navigationItem.title = "Posts"
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(navigateBackToCommunicationSection))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "send2"), style: .plain, target: self, action: #selector(handleSendMessages))
        } else {
            self.navigationItem.title = "Post"
        }
        
    }
    
    @objc func navigateBackToCommunicationSection() {
        
        let communicationsTabBarVC = CommunicationsTabBarVC()
        self.present(communicationsTabBarVC, animated: true, completion: nil)
        
    }
    
    @objc func handleRefresh() {
        
        posts.removeAll(keepingCapacity: false)
        fetchPostsAfterRefresh()
        self.collectionView?.reloadData()
        
    }
    
    func getUnreadMessageCount(withCompletion completion: @escaping(Int) -> ()) {

        let unreadCount = 2
        completion(unreadCount)
        
    }
    
    func setUnreadMessageCount() {
        if !viewSinglePost {
            getUnreadMessageCount { (unreadMessageCount) in
                guard unreadMessageCount != 0 else { return }
                self.navigationController?.navigationBar.addSubview(self.messageNotificationView)
                self.messageNotificationView.anchor(top: self.navigationController?.navigationBar.topAnchor, left: nil, bottom: nil, right: self.navigationController?.navigationBar.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 20, height: 20)
                self.messageNotificationView.layer.cornerRadius = 20 / 2
                self.messageNotificationView.notificationLabel.text = "\(unreadMessageCount)"
            }
        }
    }
    
    @objc func handleSendMessages() {
        
        print("handleSendMessages")
        
        let messagesController = MessagesController()
        self.messageNotificationView.isHidden = true
        navigationController?.pushViewController(messagesController, animated: true)
        
    }
    
    func handleUsernameTapped(for cell: MainFeedCell) {
        
        // guard let post = cell.post else { return }

        let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        profileVC.userToLoadFromAnotherVC = self.user
        
        navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    func handleOptionsTapped(for cell: MainFeedCell) {
        print("handleOptionsTapped")
    }
    
    func handleLikeTapped(for cell: MainFeedCell, isDoubleTap: Bool) {
        print("handleLikeTapped")
    }
    
    func handleCommentTapped(for cell: MainFeedCell) {
        print("handleCommentTapped")
        
        guard let post = cell.post else { return }
        let commentVC = CommentVC(collectionViewLayout: UICollectionViewFlowLayout())
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)
        
    }
    
    func handleConfigureLikeButton(for cell: MainFeedCell) {
        print("handleConfigureLikeButton")
    }
    
    func handleShowLikes(for cell: MainFeedCell) {
        print("handleShowLikes")
    }
    
    func configureCommentIndicatorView(for cell: MainFeedCell) {
        print("configureCommentIndicatorView")
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
    
    func fetchPostsAfterRefresh() {
        let post1 = Post(postId: "1", user: self.user!, caption: "test caption 1", likes: 1, imageUrl: "url here", creatorId: self.user?.userId, creationDate: Date())
        posts.append(post1)
        
        let post2 = Post(postId: "2", user: self.user!, caption: "test caption 2", likes: 2, imageUrl: "url here", creatorId: self.user?.userId, creationDate: Date())
        posts.append(post2)
        
        let post3 = Post(postId: "3", user: self.user!, caption: "test caption 3", likes: 3, imageUrl: "url here", creatorId: self.user?.userId, creationDate: Date())
        posts.append(post3)
        
        let post4 = Post(postId: "4", user: self.user!, caption: "test caption 4", likes: 4, imageUrl: "url here", creatorId: self.user?.userId, creationDate: Date())
        posts.append(post4)
        
        let post5 = Post(postId: "5", user: self.user!, caption: "test caption 5", likes: 5, imageUrl: "url here", creatorId: self.user?.userId, creationDate: Date())
        posts.append(post5)
        
        let post6 = Post(postId: "6", user: self.user!, caption: "test caption 6", likes: 6, imageUrl: "url here", creatorId: self.user?.userId, creationDate: Date())
        posts.append(post6)
        
        self.collectionView?.refreshControl?.endRefreshing()
    }

}
