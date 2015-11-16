//
//  PostCell.swift
//  mai-showcase
//
//  Created by Siew Mai Chan on 15/11/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    var request: Request?
    var likeRef: Firebase!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.userInteractionEnabled = true
    }
    
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showcaseImg.clipsToBounds = true
        
    }
    
    func configureCell(post: Post, cacheImg: UIImage?) {
        self.post = post
        
        likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        
        descriptionLbl.text = post.postDescription
        likesLbl.text = "\(post.likes)"
        
        if post.imageUrl != nil {
            if cacheImg != nil {
                self.showcaseImg.image = cacheImg
            }else {
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"])
                    .response(completionHandler: { request, response, data, error in
                        if error == nil {
                            let image = UIImage(data: data!)!
                            self.showcaseImg.image = image
                            FeedVC.imageCache.setObject(image, forKey: self.post.imageUrl!)
                        }
                    })
            }
        } else {
            showcaseImg.hidden = true
        }
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let doesNotExist = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "like-outline")
            } else {
                self.likeImg.image = UIImage(named: "like")
            }
        })
    }
    
    func likeTapped(sender:UITapGestureRecognizer) {
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let doesNotExist = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "like")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "like-outline")
                self.post.adjustLikes(false)
                self.likeRef.removeValue()
            }
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
