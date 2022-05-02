//
//  DiscoverVC.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 20/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SearchUserCell"

class DiscoverVC: UITableViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var creators : [User] = []
    var filteredCreators = [User]()
    var searchBar = UISearchBar()
    var inSearchMode = false
    var collectionView: UICollectionView!
    var collectionViewEnabled = true
    var posts = [Post]()
    var currentKey: String?
    var userCurrentKey: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SearchUserCell.self, forCellReuseIdentifier: reuseIdentifier)

        constructNavigationController()
        
        // remove separators
        tableView.separatorStyle = .none
        
        // configure search bar
        configureSearchBar()
        
        // configure collection view
        configureCollectionView()
        
        // configure refresh control
        configureRefreshControl()
        
        fetchUsers()
        fetchPosts()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredCreators.count
        } else {
            return creators.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchUserCell
        
        if inSearchMode {
            cell.user = filteredCreators[indexPath.row]
        } else {
            cell.user = creators[indexPath.row]
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if creators.count > 3 {
            if indexPath.item == creators.count - 1 {
                // fetchUsers()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var creator: User!
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if inSearchMode {
            creator = filteredCreators[indexPath.row]
        } else {
            creator = creators[indexPath.row]
        }
        
        let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        profileVC.userToLoadFromAnotherVC = creator
        
        navigationController?.pushViewController(profileVC, animated: true)
    
    }
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - (tabBarController?.tabBar.frame.height)! - (navigationController?.navigationBar.frame.height)!)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.register(SearchPostCell.self, forCellWithReuseIdentifier: "SearchPostCell")
        
        configureRefreshControl()
        
        tableView.addSubview(collectionView)
        tableView.separatorColor = .clear
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if posts.count > 20 {
            if indexPath.item == posts.count - 1 {
                //fetchPosts()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchPostCell", for: indexPath) as! SearchPostCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainFedVC = MainFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        mainFedVC.viewSinglePost = true
        mainFedVC.post = posts[indexPath.item]
        navigationController?.pushViewController(mainFedVC, animated: true)
    }
    
    // MARK: - UISearchBar
    
    func configureSearchBar() {
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.barTintColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        searchBar.tintColor = .black
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        fetchUsers()
        
        collectionView.isHidden = true
        collectionViewEnabled = false
        
        tableView.separatorColor = .lightGray
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //let searchText = searchText.lowercased()
        
        if searchText.isEmpty || searchText == " " {
            inSearchMode = false
            tableView.reloadData()
        } else {
            inSearchMode = true
            filteredCreators = creators.filter({ (user) -> Bool in
                return user.userName.contains(searchText)
            })
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        inSearchMode = false
        
        collectionViewEnabled = true
        collectionView.isHidden = false
        
        tableView.separatorColor = .clear
        tableView.reloadData()
    }
    
    // MARK: - Handlers
    
    @objc func handleRefresh() {
        posts.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchPosts()
        collectionView?.reloadData()
    }
    
    func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    func constructNavigationController() {
        
        navigationItem.title = "Discover"
        
    }
    
    func fetchUsers() {
        
        creators.removeAll(keepingCapacity: false)
        
        let creator = User(userId: "1", userName: "Creator 1", statusMessage: "Hi, I am using Chatster")
        creators.append(creator)
        
        let creator2 = User(userId: "2", userName: "Creator 2", statusMessage: "Hi, I am using Chatster")
        creators.append(creator2)
        
        let creator3 = User(userId: "3", userName: "Creator 3", statusMessage: "Hi, I am using Chatster")
        creators.append(creator3)
        
        self.tableView.reloadData()
        
    }
    
    func fetchPosts() {
        self.tableView.refreshControl?.endRefreshing()
        
        let post1 = Post(postId: "1", user: self.creators[0], caption: "test caption", likes: 5, imageUrl: "url here", creatorId: self.creators[0].userId, creationDate: Date())
        posts.append(post1)
        
        let post2 = Post(postId: "2", user: self.creators[0], caption: "test caption 2", likes: 1, imageUrl: "url here", creatorId: self.creators[0].userId, creationDate: Date())
        posts.append(post2)
        
        let post3 = Post(postId: "3", user: self.creators[0], caption: "test caption 3", likes: 1, imageUrl: "url here", creatorId: self.creators[0].userId, creationDate: Date())
        posts.append(post3)
        
        self.collectionView.reloadData()
    }

}
