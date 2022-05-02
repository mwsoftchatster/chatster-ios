//
//  FollowVC.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 21/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FollowCell"

class FollowVC: UITableViewController {
    
    var viewFollowers = false
    var viewFollowing = false
    
    var creators : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FollowCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        if viewFollowers {
            navigationItem.title = "Followers"
        } else {
            navigationItem.title = "Following"
        }
        
        let creator = User(userId: "1", userName: "Creator 1", statusMessage: "Hi, I am using Chatster")
        creators.append(creator)
        
        let creator2 = User(userId: "2", userName: "Creator 2", statusMessage: "Hi, I am using Chatster")
        creators.append(creator2)
        
        let creator3 = User(userId: "3", userName: "Creator 3", statusMessage: "Hi, I am using Chatster")
        creators.append(creator3)
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creators.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FollowCell
        
        cell.user = creators[indexPath.row]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}
