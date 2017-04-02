//
//  CommentCell.swift
//  KnockKnock
//
//  Created by Deepak Venkatesh on 2016-07-22.
//  Copyright © 2016 ThirtyFour. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    var comment:Comment!
    var senderName = UILabel()
    var commentText = UILabel()
    var time = UILabel()

    let smallGap:CGFloat = 5
    
    let verticalGap:CGFloat = 11
    
    var leftEdgeOffset:CGFloat = 30
    
    var textOriginX:CGFloat{
        return 7
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpSenderName()
        setUpText()
        setUpTime()
    }
    
    /*init(width:CGFloat){
     super.init(frame:CGRect())
     
     
     setUpImage()
     setUpSenderName()
     setUpText()
     //setUpTime()
     
     }*/
    
    func setUp(_ comment:Comment,width:CGFloat){
        frame.size.width = width
        self.comment = comment

        assignValues()
        positionElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    func setUpSenderName(){
        senderName.font = Font.PageSmallBold()
        senderName.textColor = UIColor.black
        senderName.numberOfLines = 0
        addSubview(senderName)
    }
    
    func setUpText(){
        commentText.numberOfLines = 0
        commentText.font = Font.PageSmall()
        commentText.textColor = UIColor.black
        commentText.frame.size.width = frame.width - textOriginX
        addSubview(commentText)
    }
    
    
    func setUpTime(){
        time.font = Font.PageSmall()
        time.textColor = globalGreyColor
        addSubview(time)
    }
    
    
    func assignValues(){
        
        senderName.preferredMaxLayoutWidth = frame.width - textOriginX
        senderName.frame.size.width = frame.width - textOriginX
        
        commentText.frame.size.width = frame.width - textOriginX
        
        senderName.text = comment.sender.alias
        
        commentText.text = comment.text
        time.text = GlobalData.FirebaseTimeStampToString(comment.time)
        
        senderName.sizeToFit()
        commentText.sizeToFit()
        time.sizeToFit()
    }
    
    func positionElements(){
        

        senderName.frame.origin.x = textOriginX
        senderName.frame.origin.y = verticalGap
        

        commentText.frame.origin.x = textOriginX
        commentText.frame.origin.y = senderName.frame.maxY + smallGap/2
        
        time.frame.origin.x = commentText.frame.origin.x
        time.frame.origin.y = commentText.frame.maxY + smallGap/2
        
        frame.size.height = time.frame.maxY + verticalGap
        
    }
}
