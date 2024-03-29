//
//  MessagesController.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 24/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "MessagesCell"

class MessagesController: UITableViewController {
    
    // MARK: - Properties
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    var user: User?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load from local db
        let user = User(userId: "1", userName: "Test User 1", statusMessage: "Hi, I am using Chatster")
        self.user = user
        
        configureNavigationBar()
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        
        fetchMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let uid = "1"
        let message = messages[indexPath.row]
        let chatPartnerId = message.getChatPartnerId()
        
        self.messages.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
 
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.delegate = self
        cell.message = messages[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        let chatPartnerId = message.getChatPartnerId()
        let cell = tableView.cellForRow(at: indexPath) as! MessageCell
        self.showChatController(forUser: self.user!)
        cell.messageTextLabel.font = UIFont.systemFont(ofSize: 12)
    }
    
    // MARK: - Handlers
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navigationController = UINavigationController(rootViewController: newMessageController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showChatController(forUser user: User) {
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        navigationController?.pushViewController(chatController, animated: true)
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Messages"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))
    }
    
    // MARK: - API
    
    func fetchMessages() {
        
        self.messages.removeAll()
        self.messagesDictionary.removeAll()
        self.tableView.reloadData()
        
        let messageId = "1"
        self.fetchMessage(withMessageId: messageId)

    }
    
    func fetchMessage(withMessageId messageId: String) {

        let message1 = Message(messageText: "Test fetch message 1", fromId: "1", toId: "2", creationDate: Date(), imageUrl: nil, imageHeight: nil, imageWidth: nil, videoUrl: nil, read: false)
        let chatPartnerId1 = message1.getChatPartnerId()
        self.messagesDictionary[chatPartnerId1] = message1
        
        let message2 = Message(messageText: "Test fetch message 2", fromId: "1", toId: "2", creationDate: Date(), imageUrl: nil, imageHeight: nil, imageWidth: nil, videoUrl: nil, read: false)
        let chatPartnerId2 = message2.getChatPartnerId()
        self.messagesDictionary[chatPartnerId2] = message2
        
        self.messages = Array(self.messagesDictionary.values)
        
        self.messages.sort(by: { (message1, message2) -> Bool in
            return message1.creationDate > message2.creationDate
        })
        
        self.tableView?.reloadData()

    }
}

extension MessagesController: MessageCellDelegate {
    
    func configureUserData(for cell: MessageCell) {
        guard let chatPartnerId = cell.message?.getChatPartnerId() else { return }

        //cell.profileImageView.loadImage(with: user.profileImageUrl)
        cell.usernameLabel.text = self.user!.userName
        
    }
}
