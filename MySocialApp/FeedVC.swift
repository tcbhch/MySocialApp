//
//  FeedVC.swift
//  MySocialApp
//
//  Created by Hyperactive5 on 13/04/2017.
//  Copyright © 2017 Hyperactive5. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImgView: CircleView!

    @IBOutlet weak var captionField: FancyField!
    @IBOutlet weak var signOutBtn: UIButton!
    
    var imagePicker:UIImagePickerController!
    
    var posts = [Post]()
    
    static var imageCache: NSCache<NSString,UIImage> = NSCache()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        signOutBtn.imageView?.contentMode = .scaleAspectFit
        signOutBtn.imageView?.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        
        imagePicker.delegate = self
        
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? [String:Any] {
                        var contains = true
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        if self.posts.count < snapshot.count {
                            self.posts.append(post)
                        } else {
                            for tempPost in self.posts {
                                if key != tempPost.postKey {
                                    contains = false
                                } else {
                                    contains = true
                                    break
                                }
                            }
                            if !contains {
                                self.posts.append(post)
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        })
    }
    @IBAction func signOutBtnPressed(_ sender: UIButton) {
        if KeychainWrapper.standard.removeObject(forKey: KEY_UID) == true {
            try! FIRAuth.auth()?.signOut()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return PostCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImgView.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func addImgTapped(_ sender: Any) {
        present(imagePicker, animated: true,completion: nil)
    }
    
    @IBAction func postBtnTapped(_ sender: UIButton) {
        guard let caption = captionField.text, caption != "" else {
            print("caption must be entered")
            return
        }
        guard let img = addImgView.image, img != UIImage(named:"add-image") else {
            print("an image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = UUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metaData) { (metaData,error) in
                if error != nil {
                    print("unable to upload image to storage")
                } else {
                    print("successfully uploaded image to storage")
                    let downloadurl = metaData?.downloadURL()?.absoluteString
                    self.postToFirebase(caption: caption, imgUrl: downloadurl!)
                }
            }
        }
    }
    
    func postToFirebase(caption:String,imgUrl:String) {
        let post:[String:Any] = [
            "caption":caption,
            "imageUrl":imgUrl,
            "likes":0
        ]
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        addImgView.image = UIImage(named:"add-image")
        tableView.reloadData()
    }
    
}
