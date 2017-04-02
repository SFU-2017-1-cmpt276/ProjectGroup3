//
//  NotificationCell.swift
//  FeelApp
//
//  Created by Deepak Venkatesh on 2017-03-30.
//  Copyright © 2017 CMPT276. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    var post:Post!
    var someLabel = UILabel()
    var timeLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(someLabel)
        addSubview(timeLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(post:Post,width:CGFloat){
        self.post = post
        
        //there are 5 likes on your post!
        //there are 2 comments and 5 likes on your post!
        //there are 2 comments on your post!
        
        let thereAreString = NSMutableAttributedString(string: "There are ", attributes: [NSFontAttributeName:Font.PageBody()])
        let andString = NSMutableAttributedString(string: " and ", attributes: [NSFontAttributeName:Font.PageBody()])
        let onString = NSMutableAttributedString(string: " on your ", attributes: [NSFontAttributeName:Font.PageBody()])
        let font = UIFont(name: post.emotion.font.fontName, size: 20)
        let emotionString = NSMutableAttributedString(string: post.emotion.name, attributes: [NSFontAttributeName:font,NSForegroundColorAttributeName:post.emotion.color])
        let postString = NSMutableAttributedString(string: " post!", attributes: [NSFontAttributeName:Font.PageBody()])
        
        var commentsString = NSMutableAttributedString(string: "\(post.comments.count) comments", attributes: [NSFontAttributeName:Font.PageBodyBold()])
  
        var likesString = NSMutableAttributedString(string: "\(post.likes.count) likes", attributes: [NSFontAttributeName:Font.PageBodyBold()])
        
        thereAreString.append(commentsString)
        thereAreString.append(andString)
        thereAreString.append(likesString)
        thereAreString.append(onString)
        thereAreString.append(emotionString)
        thereAreString.append(postString)
        
        someLabel.frame.origin.y = 10
        someLabel.frame.origin.x = 15
        someLabel.preferredMaxLayoutWidth = width - 30
        someLabel.frame.size.width = width - 30
        someLabel.numberOfLines = 0
        someLabel.attributedText = thereAreString
        someLabel.sizeToFit()
        timeLabel.font = Font.PageSmall()
        timeLabel.textColor = globalGreyColor
        
        
        var newest:TimeInterval!
        if post.likes.count > 0{newest = post.likes[0].time}
        if post.comments.count > 0{
            if newest == nil{newest = post.comments[0].time}
            else{newest = min(post.comments[0].time,newest)}
        }
        
        timeLabel.text = GlobalData.FirebaseTimeStampToString(newest)
        timeLabel.sizeToFit()
        timeLabel.frame.origin.x = 15
        timeLabel.frame.origin.y = someLabel.frame.maxY + 5
        frame.size.height = timeLabel.frame.maxY + 10
        
    }
    

}
