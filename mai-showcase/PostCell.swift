//
//  PostCell.swift
//  mai-showcase
//
//  Created by Siew Mai Chan on 15/11/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    var request: Request?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showcaseImg.clipsToBounds = true
        
    }
    
    func configureCell(post: Post, cacheImg: UIImage?) {
        self.post = post
        
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
    }

}
