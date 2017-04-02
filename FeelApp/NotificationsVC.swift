//
//  NotificationsVC.swift
//  FeelApp
//
//  Created by Deepak Venkatesh on 2017-03-30.
//  Copyright © 2017 CMPT276. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NotificationsVC: UIViewController {

    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    var posts:[Post] = []
    var tableView = UITableView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        setUpTopView()
        setUpTableView()
        getNotifications()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        backButton.addTarget(self, action: #selector(NotificationsVC.backAction), for: .touchUpInside)
        
        topView.addSubview(backButton)
        backButton.changeToColor(UIColor.white)
        backButton.frame.origin.y = topView.frame.height - backButton.frame.height
        backButton.frame.origin.x = 0
        
        titleLabel.font = Font.PageHeaderSmall()
        titleLabel.text = "Notifications"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
        topView.addSubview(titleLabel)
        
    }
    
    func getNotifications(){
        FIRDatabase.database().reference().child("Posts").queryOrdered(byChild: "Sender ID").queryEqual(toValue: userUID).observeSingleEvent(of: .value, with: {snapshot in
            let dict = snapshot.value! as? [String:AnyObject] ?? [:]
            for (id,postDict) in dict{
                
                let post = Post()
                
                let emotionDict = postDict["Emotion"] as? [String:AnyObject] ?? [:]
                let type = emotionDict["Type"] as? String ?? ""
                post.emotion = Emotion.fromString(type)
                post.emotion.text = emotionDict["Text"] as? String ?? ""
                post.emotion.time = emotionDict["Time"] as? TimeInterval ?? TimeInterval()
                post.ID = id
                post.sender.id = postDict["Sender ID"] as? String ?? ""
                post.sender.alias = postDict["Sender Alias"] as? String ?? ""
                
                let likeDict = postDict["Likes"] as? [String:TimeInterval] ?? [:]
                for (someID,time) in likeDict{
                    let like = Like()
                    like.senderID = someID
                    like.time = time
                    post.likes.append(like)
                }
                
                //newer likes first
                post.likes.sort(by: {$0.time > $1.time})
                
                let allCommentDict = postDict["Comments"] as? [String:AnyObject] ?? [:]
                if allCommentDict.count > 0{
                    
                    
                    
                    
                }
                for (someID,commentDict) in allCommentDict{
                    let comment = Comment()
                    let person = Person()
                    person.alias = commentDict["Sender Alias"] as? String ?? ""
                    person.id = commentDict["Sender ID"] as? String ?? ""
                    comment.sender = person
                    comment.text = commentDict["Text"] as? String ?? ""
                    comment.time = commentDict["Time"] as? TimeInterval ?? TimeInterval()
                    post.comments.append(comment)
                }
                //newer comments first
                post.comments.sort(by: {$0.time < $1.time})
                
                if post.comments.count > 0 || post.likes.count > 0{
                self.posts.append(post)
                }
                
            }
            
            self.posts.sort(by: {$0.emotion.time > $1.emotion.time})
            self.tableView.reloadData()
        })
    }
    
    func setUpTableView(){
        let originY = topView.frame.maxY
        tableView.frame = CGRect(x: 0, y: originY, width: view.frame.size.width, height: view.frame.size.height - originY)
        tableView.tableFooterView = UIView()
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = globalLightGrey
        
        tableView.bounces = true
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
    }
    
    func backAction(){
        dismiss(animated: true, completion: nil)
    }

}

extension NotificationsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationCell
        cell.setUp(post: posts[indexPath.item], width: view.frame.width)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = NotificationCell(style: .default, reuseIdentifier: "asdf")
        cell.setUp(post: posts[indexPath.item], width: view.frame.width)
        return cell.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.item]
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = CommentsVC()
        vc.modalTransitionStyle = .coverVertical
        vc.post = post
        present(vc, animated: true, completion: nil)
        
    }
    
    
}
