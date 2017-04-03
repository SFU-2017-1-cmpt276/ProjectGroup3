//
//  IndividualStoryView.swift
//  KnockKnock
//
//  Created by Deepak Venkatesh on 2016-06-29.
//  Copyright © 2016 ThirtyFour. All rights reserved.
//

import UIKit

protocol CommentsViewDelegate{
    func commentDeleted(comment:Comment)->Void
}
class CommentsView: UITableView {
    var someDelegate:CommentsViewDelegate? = nil
    var comments:[Comment] = []
    
    fileprivate var cellWidth:CGFloat{
        return frame.width
    }

    var noCommentsLabel = UILabel()
    
    
    init(size:CGSize){
        super.init(frame: CGRect(origin:CGPoint.zero,size:size), style: .plain)
        setUp()
    }
    
    
    func sortAndReload(){
        comments.sort(by: {$0.time < $1.time})
        reloadData()
        
        if comments.count == 0{
            noCommentsLabel.isHidden = false
        }
        else{
            noCommentsLabel.isHidden = true
        }
        
    }
    
    fileprivate func setUp(){
        
        //createUpdates()
        
        noCommentsLabel.text = "No comments yet"
        noCommentsLabel.font = Font.NoPostsFont()
        noCommentsLabel.textColor = globalGreyColor
        noCommentsLabel.sizeToFit()
        noCommentsLabel.center.x = frame.width/2
        addSubview(noCommentsLabel)
        noCommentsLabel.isHidden = true
        noCommentsLabel.center.y = frame.height/2
        
        register(CommentCell.self, forCellReuseIdentifier: "cell")
        delegate = self
        dataSource = self
        backgroundColor = UIColor.white
        showsVerticalScrollIndicator = false
        tableFooterView = UIView()
        separatorStyle = .none
        alwaysBounceVertical = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func addComment(_ comment:Comment){
        comments.append(comment)
    }
    
    
    class NewCommentCell:UITableViewCell{
        let button = UIButton()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            addSubview(button)
            button.setTitle("Comment", for: .normal)
            button.titleLabel?.font = Font.PageBody()
            button.setTitleColor(UIColor.white, for: .normal)
            //button.layer.borderWidth = 0.75
            button.layer.cornerRadius = 3
            button.layer.borderColor = UIColor.black.cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 9, bottom: 6, right: 9)
            button.sizeToFit()
            button.backgroundColor = nowColor
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setUp(size:CGSize){
            button.center = CGPoint(x: size.width/2, y: size.height/2)
            button.frame.origin.x = 20
        }
    }
}

extension CommentsView:UITableViewDataSource,UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        
        let cell = CommentCell()
        let comment = comments[indexPath.row]
        cell.setUp(comment,width:cellWidth)
        return cell.frame.height
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentCell
        let comment = comments[indexPath.row]
        cell.setUp(comment,width:cellWidth)
        //cell.deleteButton.addTarget(self, action: #selector(CommentsView.deleteComment(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let comment = comments[(indexPath as NSIndexPath).item]
        
        if comment.sender.id != userUID{return false}
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     let comment = comments[(indexPath as NSIndexPath).item]

     if comment.sender.id != userUID{return nil}
     
     
     let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
     self.deleteComment(comment:comment)
     }
     deleteAction.backgroundColor = UIColor(white: 0.6, alpha: 1)
     return [deleteAction]
     }
    
    func deleteComment(comment:Comment){
        someDelegate?.commentDeleted(comment: comment)
    }
}
