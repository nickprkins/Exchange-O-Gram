//
//  UserProfileHeader.swift
//  Exchange-O-Gram
//
//  Created by Nick Perkins on 5/22/17.
//  Copyright © 2017 Nicholas Perkins. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
    }
    
    var user: User? {
        didSet {
            setupProfileImage()
        }
    }
    
    fileprivate func setupProfileImage() {
        guard let profileImageUrl = user?.profileImageUrl else { return }
        
        guard let url = URL(string: profileImageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //check for the error, then construct the image using data
            if let err = err {
                print("Failed to fetch profile image:", err)
                return
            }
            
            //check for response status of 200
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { print(response.debugDescription); return }
            
            guard let data = data else { return }
            
            let image = UIImage(data: data)
            
            //Get back onto the main UI thread. URLSession is done on background thread
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
            
            }.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
