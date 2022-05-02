//
//  GroupChatListTableViewController.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 14/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GroupChatListTableViewCell"

class GroupChatListTableViewController: UITableViewController {
    
    var groupChats : [GroupChat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 100
    
        fetchGroupChats()

        tableView.register(GroupChatListTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        constructNavigationController()
    }
    
    func constructNavigationController() {
        
        self.navigationItem.title = "Group Chats"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3"), style: .plain, target: self, action: #selector(navigateToCreatorsSection))
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupChats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GroupChatListTableViewCell

        cell.groupChat = groupChats[indexPath.row]

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
        
        let groupChatVC = GroupChatViewController()
        
        groupChatVC.senderId = "123456789"
        groupChatVC.senderDisplayName = groupChats[indexPath.row].groupChatName
        groupChatVC.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(groupChatVC, animated: true)
        
    }

    @objc func navigateToCreatorsSection() {

        let creatorsTabVC = CreatorsTabBarVC()
        self.present(creatorsTabVC, animated: true, completion: nil)

    }
    
    func fetchGroupChats() {
        
        let groupChat = GroupChat()
        groupChat.groupChatId = "1"
        groupChat.groupChatName = "Group Chat 1"
        groupChat.lastMessage = "Last message Group Chat 1"
        groupChat.lastMessageDate = "2019-03-14"
        groupChats.append(groupChat)
        
        let groupChat2 = GroupChat()
        groupChat2.groupChatId = "2"
        groupChat2.groupChatName = "Group Chat 2"
        groupChat2.lastMessage = "Last message Group Chat 2"
        groupChat2.lastMessageDate = "2019-03-14"
        groupChats.append(groupChat2)
        
        let groupChat3 = GroupChat()
        groupChat3.groupChatId = "3"
        groupChat3.groupChatName = "Group Chat 3"
        groupChat3.lastMessage = "Last message Group Chat 3"
        groupChat3.lastMessageDate = "2019-03-14"
        groupChats.append(groupChat3)
        
    }
    

}
