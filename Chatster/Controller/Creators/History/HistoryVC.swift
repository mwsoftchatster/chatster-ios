//
//  HistoryVC.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 20/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

private let reuseIdentifer = "HistoryItemCell"

class HistoryVC: UITableViewController, HistoryItemCellDelegate {
    
    // MARK: - Properties
    
    var timer: Timer?
    var historyItems = [HistoryItem]()
    var user: User?
    var post: Post?
    var refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load from local db
        let user = User(userId: "1", userName: "Test User 1", statusMessage: "Hi, I am using Chatster")
        self.user = user
        
        let post = Post(postId: "1", user: self.user!, caption: "test caption", likes: 5, imageUrl: "url here", creatorId: self.user?.userId, creationDate: Date())
        self.post = post
        
        // clear separator lines
        tableView.separatorColor = .clear
        
        // nav title
        navigationItem.title = "History"
        
        // register cell class
        tableView.register(HistoryItemCell.self, forCellReuseIdentifier: reuseIdentifer)
        
        // fetch history
        fetchHistory()
        
        // refresh control
        configureRefreshControl()
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! HistoryItemCell
        
        let historyItem = historyItems[indexPath.row]
        
        cell.historyItem = historyItem
        
        if historyItem.historyItemType == .Comment {
            if let commentText = historyItem.commentText {
                cell.configureHistoryItemLabel(withCommentText: commentText)
            }
            
        }
        
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let historyItem = historyItems[indexPath.row]
        
        let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        profileVC.user = historyItem.user
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    // MARK: - NotificationCellDelegate
    
    func handleFollowTapped(for cell: HistoryItemCell) {
        
        guard let user = cell.historyItem?.user else { return }
        
        cell.followButton.configure(didFollow: false)
        
//        if user.isFollowed {
//
//            // handle unfollow user
//            user.unfollow()
//            cell.followButton.configure(didFollow: false)
//        } else {
//
//            // handle follow user
//            user.follow()
//            cell.followButton.configure(didFollow: true)
//        }
    }
    
    func handlePostTapped(for cell: HistoryItemCell) {
        guard let post = cell.historyItem?.post else { return }
        guard let historyItem = cell.historyItem else { return }
        
        if historyItem.historyItemType == .Comment {
            let commentController = CommentVC(collectionViewLayout: UICollectionViewFlowLayout())
            commentController.post = post
            navigationController?.pushViewController(commentController, animated: true)
        } else {
            let mainFeedVC = MainFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
            mainFeedVC.viewSinglePost = true
            mainFeedVC.post = post
            navigationController?.pushViewController(mainFeedVC, animated: true)
        }
    }
    
    // MARK: - Handlers
    
    @objc func handleRefresh() {
        self.historyItems.removeAll()
        self.tableView.reloadData()
        fetchHistory()
        refresher.endRefreshing()
    }
    
    @objc func handleSortNotifications() {
        self.historyItems.sort { (historyItem1, historyItem2) -> Bool in
            return historyItem1.creationDate > historyItem2.creationDate
        }
        self.tableView.reloadData()
    }
    
    func handleReloadTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleSortNotifications), userInfo: nil, repeats: false)
    }
    
    func configureRefreshControl() {
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.tableView.refreshControl = refresher
    }
    
    // MARK: - API
    
    func getCommentData(forHistoryItem historyItem: HistoryItem) {
        
        guard let postId = historyItem.postId else { return }
        guard let commentId = historyItem.commentId else { return }
        historyItem.commentText = "Test comment text"
        
    }
    
    func fetchHistory() {
        
        let historyItem1 = HistoryItem(user: self.user!, post: self.post, userId: "1", postId: "1", type: 1, historyItemType: 1, commentId: "1", commentText: "Test comment text", creationDate: Date(), checked: false)
        if historyItem1.historyItemType == .Comment {
            self.getCommentData(forHistoryItem: historyItem1)
        }
            
        self.historyItems.append(historyItem1)
        
        let historyItem2 = HistoryItem(user: self.user!, post: self.post, userId: "1", postId: "1", type: 2, historyItemType: 2, commentId: "1", commentText: "Test comment text 2", creationDate: Date(), checked: false)
        if historyItem2.historyItemType == .Comment {
            self.getCommentData(forHistoryItem: historyItem2)
        }
        
        self.historyItems.append(historyItem2)
        
        let historyItem3 = HistoryItem(user: self.user!, post: self.post, userId: "1", postId: "1", type: 3, historyItemType: 3, commentId: "1", commentText: "Test comment text 3", creationDate: Date(), checked: false)
        if historyItem3.historyItemType == .Comment {
            self.getCommentData(forHistoryItem: historyItem3)
        }
        
        self.historyItems.append(historyItem3)
        
        self.handleReloadTable()
        
    }

}
