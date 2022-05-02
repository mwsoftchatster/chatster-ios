//
//  CreatePostVC.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 20/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class CreatePostVC: UIViewController {
    
    var selectedImage: UIImage?
    
    let photoImageView: UIImageView = {
        let piv = UIImageView()
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        piv.backgroundColor = .blue
        
        return piv
    }()
    
    let captionTextView: UITextView = {
        let ctv = UITextView()
        ctv.backgroundColor = UIColor.groupTableViewBackground
        ctv.font = UIFont(name: "Gotham Book", size: 12)
        
        return ctv
    }()
    
    let createPostBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        btn.setTitle("Upload", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleCreateNewPost), for: .touchUpInside)
        
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        view.addSubview(photoImageView)
        photoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: view.topAnchor, left: photoImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 100)
        
        view.addSubview(createPostBtn)
        createPostBtn.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 40)
        
        loadImage()
    }
    
    func loadImage() {
        
        guard let selectedImage = self.selectedImage else { return }
        
        photoImageView.image = selectedImage
        
    }
    
    @objc func handleCreateNewPost() {
        
        guard
            let caption = captionTextView.text,
            let _ = photoImageView.image else { return }
        
        print("Post caption --> \(caption)")
        
        self.dismiss(animated: true) {
            
            self.tabBarController?.selectedIndex = 0
            
        }
    }
    

}
