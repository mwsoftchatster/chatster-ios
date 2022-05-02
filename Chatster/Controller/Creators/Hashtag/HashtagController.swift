//
//  HashtagController.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 23/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "HashtagCell"

class HashtagController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properites
    
    var posts = [Post]()
    var hashtag: String?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(HashtagCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        fetchPosts()
    }
    
    // MARK: - UICollectionViewFlowLayout
    
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
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HashtagCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainFeedVC = MainFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        mainFeedVC.viewSinglePost = true
        mainFeedVC.post = posts[indexPath.item]
        navigationController?.pushViewController(mainFeedVC, animated: true)
    }
    
    // MARK: - Handlers
    
    func configureNavigationBar() {
        guard let hashtag = self.hashtag else { return }
        navigationItem.title = hashtag
    }
    
    // MARK: - API
    
    func fetchPosts() {
        guard let hashtag = self.hashtag else { return }
        

    }
}
