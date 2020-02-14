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
import Firebase

private let reuseIdentifier = "NewMessageCell"

class NewMessageController: UITableViewController {
    
    // MARK: - Properties
    
    var users = [User]()
    var messagesController: MessagesController?
    var user: User?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load from local db
        let user = User(userId: "1", userName: "Test User 1", statusMessage: "Hi, I am using Chatster")
        self.user = user
        
        configureNavigationBar()
        
        // register cell
        tableView.register(NewMessageCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // removes separator views from unused rows
        tableView.tableFooterView = UIView(frame: .zero)
        
        fetchUsers()
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewMessageCell
        
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesController?.showChatController(forUser: user)
        }
    }
    
    // MARK: - Handlers
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func configureNavigationBar() {
        navigationItem.title = "New Message"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    // MARK: - API
    
    func fetchUsers() {
        self.users.append(self.user!)
        self.tableView.reloadData()
    }
}
