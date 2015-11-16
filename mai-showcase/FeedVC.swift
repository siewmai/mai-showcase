//
//  FeedVC.swift
//  mai-showcase
//
//  Created by Siew Mai Chan on 15/11/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var postImg: UIImageView!
    
    var imagePicker: UIImagePickerController!
    var posts = [Post]()
    
    static var imageCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 444
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    if let dictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: dictionary)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            cell.request?.cancel()
            
            var image: UIImage?
            
            if let url = post.imageUrl {
                image = FeedVC.imageCache.objectForKey(url) as? UIImage
            }
            cell.configureCell(post, cacheImg: image)
            return cell
        } else {
            return PostCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil {
            return 200
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        postImg.image = image
    }
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        print("display image")
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func makePost(sender: AnyObject) {
    }
    
}
