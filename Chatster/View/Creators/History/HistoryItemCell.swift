//
//  HistoryItemCell.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 24/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class HistoryItemCell: UITableViewCell {
    
    // MARK: - Properties
    
    var delegate: HistoryItemCellDelegate?
    
    var historyItem: HistoryItem? {
        
        didSet {
            
            guard let user = historyItem?.user else { return }
            //guard let profileImageUrl = user.profileImageUrl else { return }
            
            // configure notification type
            configureHistoryItemType()
            
            // configure notification label
            configureHistoryItemLabel(withCommentText: nil)
            
            //profileImageView.loadImage(with: profileImageUrl)
            
//            if let post = notification?.post {
//                postImageView.loadImage(with: post.imageUrl)
//            }
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView(image: UIImage(named: "avatarPlaceholder"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let historyItemLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var postImageView: CustomImageView = {
        let iv = CustomImageView(image: UIImage(named: "test"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        let postTap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        postTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(postTap)
        
        return iv
    }()
    
    // MARK: - Handlers
    
    @objc func handleFollowTapped() {
        delegate?.handleFollowTapped(for: self)
    }
    
    @objc func handlePostTapped() {
        delegate?.handlePostTapped(for: self)
    }
    
    func configureHistoryItemLabel(withCommentText commentText: String?) {
        guard let historyItem = self.historyItem else { return }
        guard let user = historyItem.user else { return }
        //guard let username = user.userName else { return }
        guard let historyItemDate = getHistoryItemTimeStamp() else { return }
        
        var historyItemMessage: String!
        
        if let commentText = commentText {
            if historyItem.historyItemType != .CommentMention {
                historyItemMessage = "\(historyItem.historyItemType.description): \(commentText)"
            }
        } else {
            historyItemMessage = historyItem.historyItemType.description
        }
        
        let attributedText = NSMutableAttributedString(string: "Test User 1", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: historyItemMessage, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: " \(historyItemDate)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        historyItemLabel.attributedText = attributedText
    }
    
    func configureHistoryItemType() {
        
        guard let historyItem = self.historyItem else { return }
        guard let user = historyItem.user else { return }
        
        
        if historyItem.historyItemType != .Follow {
            
            // notification type is comment or like
            addSubview(postImageView)
            postImageView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 40, height: 40)
            postImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            followButton.isHidden = true
            postImageView.isHidden = false
            
        } else {
            
            // notification type is follow
            addSubview(followButton)
            followButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 90, height: 30)
            followButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            followButton.layer.cornerRadius = 3
            followButton.isHidden = false
            postImageView.isHidden = true
            
//            user.checkIfUserIsFollowed(completion: { (followed) in
//
//                if followed {
//                    self.followButton.setTitle("Following", for: .normal)
//                    self.followButton.setTitleColor(.black, for: .normal)
//                    self.followButton.layer.borderWidth = 0.5
//                    self.followButton.layer.borderColor = UIColor.lightGray.cgColor
//                    self.followButton.backgroundColor = .white
//                } else {
//                    self.followButton.setTitle("Follow", for: .normal)
//                    self.followButton.setTitleColor(.white, for: .normal)
//                    self.followButton.layer.borderWidth = 0
//                    self.followButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
//                }
//            })
        }
        
        addSubview(historyItemLabel)
        historyItemLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 108, width: 0, height: 0)
        historyItemLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        print("DEBUG: Follow button width constraint is \(followButton.frame.width)")
    }
    
    func getHistoryItemTimeStamp() -> String? {
        
        guard let historyItem = self.historyItem else { return nil }
        
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        dateFormatter.maximumUnitCount = 1
        dateFormatter.unitsStyle = .abbreviated
        let now = Date()
        return dateFormatter.string(from: historyItem.creationDate, to: now)
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 40 / 2
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
