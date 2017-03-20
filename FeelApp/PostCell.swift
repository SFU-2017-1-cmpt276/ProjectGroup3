//
//  PostCell.swift
//  FeelApp
//
//  Created by Deepak Venkatesh on 2017-03-15.
//  Copyright © 2017 CMPT276. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    var post:Post!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var mainText: UILabel!
    @IBOutlet var emotionText: UILabel!
    
    @IBOutlet var likeImage: UIImageView!
    @IBOutlet var likeText: UILabel!
    @IBOutlet var likeView: UIView!
    
    @IBOutlet var commentImage: UIImageView!
    @IBOutlet var commentText: UILabel!
    @IBOutlet var commentView: UIView!
    
    let calendar = Calendar.current
    let formatter = DateFormatter()
    
    @IBOutlet var line: UILabel!
    @IBOutlet var background: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeView.backgroundColor = UIColor.clear
        commentView.backgroundColor = UIColor.clear
        likeImage.changeToColor(UIColor.white)
        commentImage.changeToColor(UIColor.white)
        likeText.font = Font.PageSmall()
        likeText.textColor = UIColor.white
        commentText.font = Font.PageSmall()
        commentText.textColor = UIColor.white
        timeLabel.font = Font.PageSmall()
        timeLabel.textColor = UIColor.white
        nameLabel.font = Font.PageBody()
        nameLabel.textColor = UIColor.white
                
        
        mainText.font = Font.PageBodyBold()
        
        formatter.calendar = calendar
        formatter.timeStyle = .short
        formatter.dateStyle = .short
    }
    
    func setUp(post:Post){
        self.post = post
        mainText.textColor = UIColor.white
        mainText.text = post.emotion.text
        mainText.font = Font.PageBodyBold()
        nameLabel.text = post.sender.alias
        likeText.text = String(post.likeCount)
        commentText.text = String(post.commentCount)
        emotionText.text = post.emotion.name
        emotionText.font = UIFont(name:post.emotion.font.fontName,size: post.emotion.font.pointSize-3)
        emotionText.textColor = UIColor.white
        timeLabel.text = GlobalData.FirebaseTimeStampToString(post.emotion.time)
        line.backgroundColor = UIColor.white
        backgroundView?.backgroundColor = post.emotion.color

    }
    
}
