//
//  CommentVC.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 23/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifer = "CommentCell"

class CommentVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var comments = [Comment]()
    var post: Post?
    var user: User?
    
    lazy var containerView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let containerView = CommentInputAccesoryView(frame: frame)
        
        containerView.delegate = self
        
        return containerView
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load from local db
        let user = User(userId: "1", userName: "Test User 1", statusMessage: "Hi, I am using Chatster")
        self.user = user
        
        // configure collection view
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
        // navigation title
        navigationItem.title = "Comments"
        
        // register cell class
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifer)
        
        // fetch comments
        fetchComments()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifer, for: indexPath) as! CommentCell
        
//        handleHashtagTapped(forCell: cell)
//
//        handleMentionTapped(forCell: cell)
        
        cell.comment = comments[indexPath.item]
        
        return cell
    }
    
    // MARK: - Handlers
    
    func handleHashtagTapped(forCell cell: CommentCell) {
        print("handleMentionTapped")
        
//        cell.commentLabel.handleHashtagTap { (hashtag) in
//            let hashtagController = HashtagController(collectionViewLayout: UICollectionViewFlowLayout())
//            hashtagController.hashtag = hashtag.lowercased()
//            self.navigationController?.pushViewController(hashtagController, animated: true)
//        }
    }
    
    func handleMentionTapped(forCell cell: CommentCell) {
        print("handleMentionTapped")
//        cell.commentLabel.handleMentionTap { (username) in
//            self.getMentionedUser(withUsername: username)
//        }
    }
    
    // MARK: - API
    
    func fetchComments() {
        // guard let postId = self.post?.postId else { return }
        
        let comment1 = Comment(user: self.user!, commentId: "1", commentText: "Test comment 1", creationDate: Date())
        comments.append(comment1)
        
        let comment2 = Comment(user: self.user!, commentId: "2", commentText: "Test comment 2", creationDate: Date())
        comments.append(comment2)
        
        let comment3 = Comment(user: self.user!, commentId: "3", commentText: "Test comment 3", creationDate: Date())
        comments.append(comment3)

    }
    
    func uploadCommentNotificationToServer() {

        print("CommentVC uploadCommentNotificationToServer")

    }
}

extension CommentVC: CommentInputAccesoryViewDelegate {
    
    func didSubmit(forComment comment: String) {
        
        print("CommentVC didSubmit")
        let newComment = Comment(user: self.user!, commentId: "3", commentText: comment, creationDate: Date())
        comments.append(newComment)
        self.collectionView?.reloadData()
        
        //self.uploadCommentNotificationToServer()
        
//        if comment.contains("@") {
//            self.uploadMentionNotification(forPostId: postId, withText: comment, isForComment: true)
//        }
        
        self.containerView.clearCommentTextView()
    }
}
