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
    
    @IBOutlet var line: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeView.backgroundColor = UIColor.white
        commentView.backgroundColor = UIColor.white
        likeImage.changeToColor(globalGreyColor)
        commentImage.changeToColor(globalGreyColor)
        likeText.font = Font.PageSmall()
        likeText.textColor = globalGreyColor
        commentText.font = Font.PageSmall()
        commentText.textColor = globalGreyColor
        timeLabel.font = Font.PageSmall()
        timeLabel.textColor = globalGreyColor
        nameLabel.font = Font.PageBody()
        nameLabel.textColor = globalGreyColor
        
        
        mainText.font = Font.PageBodyBold()
        
        formatter.calendar = calendar
        formatter.timeStyle = .short
        formatter.dateStyle = .short
    }
    
    func setUp(post:Post){
        self.post = post
        mainText.textColor = post.emotion.color
        mainText.text = post.emotion.text
        nameLabel.text = ""//post.sender.alias
        likeText.text = String(post.likeCount)
        commentText.text = String(post.commentCount)
        emotionText.text = post.emotion.name
        emotionText.font = UIFont(name:post.emotion.font.fontName,size: post.emotion.font.pointSize-3)
        emotionText.textColor = post.emotion.color
        timeLabel.text = GlobalData.FirebaseTimeStampToString(post.emotion.time)
        line.backgroundColor = globalLightGrey
    }
    
}
