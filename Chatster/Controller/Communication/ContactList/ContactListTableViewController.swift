//
//  ContactListTableViewController.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 14/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ContactListTableViewCell"

class ContactListTableViewController: UITableViewController {
    
    var contacts : [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 100
        
        fetchContacts()
        
        tableView.register(ContactListTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        constructNavigationController()
    }
    
    func constructNavigationController() {
        
        self.navigationItem.title = "Contacts"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3"), style: .plain, target: self, action: #selector(navigateToCreatorsSection))
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ContactListTableViewCell

        cell.user = contacts[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @objc func navigateToCreatorsSection() {

        let creatorsTabVC = CreatorsTabBarVC()
        self.present(creatorsTabVC, animated: true, completion: nil)

    }
    
    func fetchContacts() {
        
        let contact = User(userId: "1", userName: "Contact 1", statusMessage: "Hi, I am using Chatster")
        contacts.append(contact)
        
        let contact2 = User(userId: "2", userName: "Contact 2", statusMessage: "Hi, I am using Chatster")
        contacts.append(contact2)
        
        let contact3 = User(userId: "3", userName: "Contact 3", statusMessage: "Hi, I am using Chatster")
        contacts.append(contact3)
        
    }
    

}
