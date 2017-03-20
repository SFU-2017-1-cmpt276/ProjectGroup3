//
//  FeedVC.swift
//  FeelApp
//
//  Created by Deepak Venkatesh on 2017-03-15.
//  Copyright © 2017 CMPT276. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView = UITableView()
    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    var posts:[Post] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle{return UIStatusBarStyle.lightContent}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTopView()
        setUpTableView()
        getPosts()
    }
    
    func setUpTableView(){
        let originY = topView.frame.maxY
        tableView.frame = CGRect(x: 0, y: originY, width: view.frame.size.width, height: view.frame.size.height - originY)
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName:"PostCell",bundle:nil), forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.separatorColor = globalLightGrey
        
        tableView.bounces = true
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
    }
    
    func setUpTopView(){
        let size = CGSize(width: 50, height: 50)
        let inset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        
        topView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: 70))
        view.addSubview(topView)
        topView.backgroundColor = nowColor
        
        backButton.frame.size = size
        backButton.setImage(#imageLiteral(resourceName: "leftArrowIcon"), for: .normal)
        backButton.contentEdgeInsets = inset
        backButton.addTarget(self, action: #selector(FeedVC.backAction), for: .touchUpInside)
        
        topView.addSubview(backButton)
        backButton.changeToColor(UIColor.white)
        backButton.frame.origin.y = topView.frame.height - backButton.frame.height
        backButton.frame.origin.x = 0
        
        titleLabel.font = Font.PageHeaderSmall()
        titleLabel.text = "Feed"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
        topView.addSubview(titleLabel)
    }
    
    func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    func getPosts(){
        
        FIRDatabase.database().reference().child("Posts").observeSingleEvent(of: .value, with: {allSnap in
            let hello = userUID
            let dict = allSnap.value as? [String:AnyObject] ?? [:]
            
            for (id,postDict) in dict{
                
                let post = Post()
                
                let emotionDict = postDict["Emotion"] as? [String:AnyObject] ?? [:]
                let type = emotionDict["Type"] as? String ?? ""
                post.emotion = Emotion.fromString(type)
                post.emotion.text = emotionDict["Text"] as? String ?? ""
                post.emotion.time = emotionDict["Time"] as? TimeInterval ?? TimeInterval()
                
                post.sender.id = postDict["Sender ID"] as? String ?? ""
                post.sender.alias = postDict["Sender Alias"] as? String ?? ""
                
                self.posts.append(post)


                
            }
            self.posts.sort(by: {$0.emotion.time > $1.emotion.time})
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! PostCell
        cell.setUp(post: posts[indexPath.row])
        return cell
    }

}
