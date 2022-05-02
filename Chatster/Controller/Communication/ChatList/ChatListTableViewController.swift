//
//  ChatListTableViewController.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 14/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import Alamofire
import Crashlytics

private let reuseIdentifier = "ChatListTableViewCell"

class ChatListTableViewController: UITableViewController {
    
    var followersRequest: FollowersRequest?
    var followingRequest: FollowingRequest?
    var historyRequest: HistoryRequest?
    var postCommentsRequest: PostCommentsRequest?
    var mainFeedRequest: MainFeedRequest?
    var creatorProfileRequest: CreatorProfileRequest?
    var discoverFeedRequest: DiscoverFeedRequest?
    
    var chats : [Chat] = []
    var followers : [Follower] = []
    var historyItems : [History] = []
    var postComments : [PostComment] = []
    var creatorPosts : [CreatorPost] = []

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.rowHeight = 100
        
        tableView.register(ChatListTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        constructNavigationController()
        
        fetchChats()
        
        let e2eHelper = E2EChatHelper()
        e2eHelper.executeObjcFunc()
        e2eHelper.e2eTest()
        
//        followersRequest = FollowersRequest()
//        self.getFollowers(followersRequest: followersRequest!, creatorName: "nikolaj", userId: "31645572649")
        
//        followingRequest = FollowingRequest()
//        self.getFollowing(followingRequest: followingRequest!, creatorName: "nikolaj", userId: "31645572649")
        
//        historyRequest = HistoryRequest()
//        self.getHistory(historyRequest: historyRequest!, creatorName: "nikolaj", userId: "31645572649")
        
//        postCommentsRequest = PostCommentsRequest()
//        self.getPostComments(postCommentsRequest: postCommentsRequest!, postUUID: "9d80d94f82d245db9842a6da4b59145d")
        
//        mainFeedRequest = MainFeedRequest()
//        self.getMainFeed(mainFeedRequest: mainFeedRequest!, creator: 31645572649, creatorsName: "nikolaj")
        
//        creatorProfileRequest = CreatorProfileRequest()
//        self.getCreatorProfile(creatorPofileRequest: creatorProfileRequest!, creatorName: "nikolaj", userId: 31645572649)
        
//        discoverFeedRequest = DiscoverFeedRequest()
//        self.getDiscoverFeed(discoverFeedRequest: discoverFeedRequest!, userId: 31645572649)
        
        let users = PhoneContacts.getContacts()
        for user in users {
            print("\(user.userName) -- \(user.userId) -- \(user.statusMessage)")
        }
        
    }
    
    func constructNavigationController() {
        
        self.navigationItem.title = "Chats"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3"), style: .plain, target: self, action: #selector(navigateToCreatorsSection))
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChatListTableViewCell

        cell.chat = chats[indexPath.row]

        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            print("Delete \(indexPath)")
            
        }
        
        return [deleteAction]
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let chatVC = ChatViewController()
        
        chatVC.senderId = "123456789"
        chatVC.senderDisplayName = chats[indexPath.row].contactName
        chatVC.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(chatVC, animated: true)
        
    }

    @objc func navigateToCreatorsSection() {

        let creatorsTabVC = CreatorsTabBarVC()
        self.present(creatorsTabVC, animated: true, completion: nil)

    }
    
    func fetchChats() {
        
        let chat = Chat()
        chat.chatId = "1"
        chat.contactName = "User 1"
        chat.lastMessage = "Last message User 1"
        chat.lastMessageDate = "2019-03-14"
        chats.append(chat)
        
        let chat2 = Chat()
        chat2.chatId = "2"
        chat2.contactName = "User 2"
        chat2.lastMessage = "Last message User 2"
        chat2.lastMessageDate = "2019-03-14"
        chats.append(chat2)
        
        let chat3 = Chat()
        chat3.chatId = "3"
        chat3.contactName = "User 3"
        chat3.lastMessage = "Last message User 3"
        chat3.lastMessageDate = "2019-03-14"
        chats.append(chat3)
        
    }
    
    func displayAlert(withTitle title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }
    
    func getFollowers(followersRequest: FollowersRequest, creatorName: String, userId: String) {
        followersRequest.getFollowers(creatorName: creatorName, userId: userId) { json, error in
            do {
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                let followers = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
                
                for follower in followers! {
                    let flwr = try Follower(json: follower as! [String : Any])
                    self.followers.append(flwr)
                }
            } catch {
                print("catch")
            }
        }
    }
    
    func getFollowing(followingRequest: FollowingRequest, creatorName: String, userId: String) {
        followingRequest.getFollowing(creatorName: creatorName, userId: userId) { json, error in
            do {
                // Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                // In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                let following = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
                
                for follower in following! {
                    let flwr = try Follower(json: follower as! [String : Any])
                    self.followers.append(flwr)
                }
                
            } catch {
                print("catch")
            }
        }
    }
    
    func getHistory(historyRequest: HistoryRequest, creatorName: String, userId: String) {
        historyRequest.getHistory(creatorName: creatorName, userId: userId) { json, error in
            do {
                // Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                // In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [AnyObject].
                let result = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
                
                for history in result! {
                    let hstr = try History(json: history as! [String : Any])
                    self.historyItems.append(hstr)
                }
                
            } catch {
                print("catch")
            }
        }
    }
    
    func getPostComments(postCommentsRequest: PostCommentsRequest, postUUID: String) {
        postCommentsRequest.getPostComments(postUUID: postUUID) { json, error in
            do {
                // Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                // In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [AnyObject].
                let result = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
                print(result!)
                for postComment in result! {
                    let comment = try PostComment(json: postComment as! [String : Any])
                    self.postComments.append(comment)
                }
                
            } catch {
                print("catch")
            }
        }
    }
    
    func getMainFeed(mainFeedRequest: MainFeedRequest, creator: Int64, creatorsName: String) {
        mainFeedRequest.getPosts(creator: creator, creatorsName: creatorsName) { json, error in
            do {
                // Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                // In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [AnyObject].
                let result = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
 
                for post in result! {
                    let creatorPost = try CreatorPost(json: post as! [String : Any])
                    self.creatorPosts.append(creatorPost)
                }
                
            } catch {
                print("catch")
            }
        }
    }
    
    func getCreatorProfile(creatorPofileRequest: CreatorProfileRequest, creatorName: String, userId: Int64) {
        creatorPofileRequest.getCreatorProfile(creatorName: creatorName, userId: userId) { json, error in
            do {
                // Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                // In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [AnyObject].
                let result = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
                
                let creator = try Creator(json: result as! [String : Any])
                
            } catch {
                print("catch")
            }
        }
    }
    
    func getDiscoverFeed(discoverFeedRequest: DiscoverFeedRequest, userId: Int64) {
        discoverFeedRequest.getPosts(userId: userId) { json, error in
            do {
                // Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                // In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [AnyObject].
                let result = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
                
                for post in result! {
                    let creatorPost = try CreatorPost(json: post as! [String : Any])
                    self.creatorPosts.append(creatorPost)
                }
                
            } catch {
                print("catch")
            }
        }
    }
    
}
