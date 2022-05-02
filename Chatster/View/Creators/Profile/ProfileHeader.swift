//
//  ProfileHeader.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 20/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class ProfileHeader: UICollectionViewCell {
    
    var delegate: ProfileHeaderDelegate?
    
    var user: User? {
        
        didSet {
            let name = user?.userName
            userName.text = name
            
            let status = user?.statusMessage
            userStatus.text = status
        }
        
    }
    
    let profileImageView: UIImageView = {
        let piv = UIImageView(image: UIImage(named: "avatarPlaceholder"))
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        piv.backgroundColor = .lightGray
        
        
        return piv
    }()
    
    let userName: UILabel = {
        let userName = UILabel()
        userName.font = UIFont(name: "Gotham Book", size: 18)
        userName.textAlignment = .left
        
        return userName
    }()
    
    lazy var followUnfollowButton: UIButton = {
        var followUnfollowButton = UIButton(type: .system)
        followUnfollowButton.setImage(UIImage(named: "profile_selected"), for: .normal)
        followUnfollowButton.addTarget(self, action: #selector(followUnfollowTapped), for: .touchUpInside)
        
        return followUnfollowButton
    }()
    
    let userStatus: UILabel = {
        let userStatus = UILabel()
        userStatus.font = UIFont(name: "Gotham Book", size: 18)
        userStatus.textAlignment = .left
        
        return userStatus
    }()
    
    let followersLb: UILabel = {
        let followers = UILabel()
        followers.text = "Followers"
        followers.font = UIFont(name: "Gotham Book", size: 14)
        followers.textAlignment = .center
        
        return followers
    }()
    
    lazy var followersNr: UILabel = {
        let followers = UILabel()
        followers.text = "100K"
        followers.font = UIFont(name: "Gotham Book", size: 18)
        followers.textAlignment = .center
        
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(followersTapped))
        followersTap.numberOfTapsRequired = 1
        
        followers.isUserInteractionEnabled = true
        followers.addGestureRecognizer(followersTap)
        
        return followers
    }()
    
    let followingLb: UILabel = {
        let following = UILabel()
        following.text = "Following"
        following.font = UIFont(name: "Gotham Book", size: 14)
        following.textAlignment = .center
        
        return following
    }()
    
    lazy var followingNr: UILabel = {
        let following = UILabel()
        following.text = "100"
        following.font = UIFont(name: "Gotham Book", size: 18)
        following.textAlignment = .center
        
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(followingTapped))
        followingTap.numberOfTapsRequired = 1
        
        following.isUserInteractionEnabled = true
        following.addGestureRecognizer(followingTap)
        
        return following
    }()
    
    let postsLb: UILabel = {
        let posts = UILabel()
        posts.text = "Posts"
        posts.font = UIFont(name: "Gotham Book", size: 14)
        posts.textAlignment = .center
        
        return posts
    }()
    
    lazy var postsNr: UILabel = {
        let posts = UILabel()
        posts.text = "10"
        posts.font = UIFont(name: "Gotham Book", size: 18)
        posts.textAlignment = .center
        
        return posts
    }()
    
    let statsDelimeterTopView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    let statsDelimeterBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(userName)
        userName.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        
        addSubview(followUnfollowButton)
        followUnfollowButton.anchor(top: self.topAnchor, left: userName.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 16, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 40, height: 40)
        
        addSubview(userStatus)
        userStatus.anchor(top: userName.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        addSubview(statsDelimeterTopView)
        statsDelimeterTopView.anchor(top: profileImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        let followersStack = UIStackView(arrangedSubviews: [followersLb, followersNr])
        
        followersStack.axis = .vertical
        followersStack.spacing = 1
        followersStack.distribution = .fillEqually
        
        let followingStack = UIStackView(arrangedSubviews: [followingLb, followingNr])
        
        followingStack.axis = .vertical
        followingStack.spacing = 1
        followingStack.distribution = .fillEqually
        
        let postsStack = UIStackView(arrangedSubviews: [postsLb, postsNr])
        
        postsStack.axis = .vertical
        postsStack.spacing = 1
        postsStack.distribution = .fillEqually
        
        let userStatsStack = UIStackView(arrangedSubviews: [followersStack, followingStack, postsStack])
        userStatsStack.axis = .horizontal
        userStatsStack.spacing = 1
        userStatsStack.distribution = .fillEqually
        
        addSubview(userStatsStack)
        userStatsStack.anchor(top: statsDelimeterTopView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
        
        addSubview(statsDelimeterBottomView)
        statsDelimeterBottomView.anchor(top: userStatsStack.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func followUnfollowTapped() {
        delegate?.handleFollowUnfollowTapped(for: self)
    }
    
    @objc func followersTapped() {
        delegate?.handleFollowersTapped(for: self)
    }
    
    @objc func followingTapped() {
        delegate?.handleFollowingTapped(for: self)
    }
    
}
