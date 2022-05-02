//
//  CreatorPostCell.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 22/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class CreatorPostCell: UICollectionViewCell {
    
    var post: Post? {
        
        didSet {
            guard let _ = post?.imageUrl else { return }
            // postImageView.loadImage(with: imageUrl)
        }
        
    }
    
    let postImageView: UIImageView = {
        let piv = UIImageView(image: UIImage(named: "test"))
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        
        return piv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
