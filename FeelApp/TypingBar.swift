//
//  TypingBar.swift
//  KnockKnock
//
//  Created by Deepak Venkatesh on 2016-06-25.
//  Copyright © 2016 ThirtyFour. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

//for updates vc so it can reposition the camera button so that its always centered vertically with send button, even when text field becomes multiple lines
protocol TypingBarDelegate{
    func textViewTextChanged()->Void
    func typingBarClosed()->Void
}
class TypingBar: UIView, UITextViewDelegate {
    
    var delegate: TypingBarDelegate?
    let textView = KMPlaceholderTextView()
    let sendButton = UIButton()
    let elementOffset:CGFloat = 6
    var placeholder = "Add comment..."
    var placeholderColor = globalGreyColor
    static var Height:CGFloat = 50
    
    var textViewButtonOffset:CGFloat = 0
    
    var textWidth:CGFloat = 0
    
    init (width:CGFloat,textViewButtonOffset:CGFloat = 0){
        super.init(frame: CGRect())
        self.textViewButtonOffset = textViewButtonOffset
        frame.size = CGSize(width: width, height: TypingBar.Height)
        setUpSendButton()
        setUpTextView()
        setUpView()
    }
    
    convenience init(width:CGFloat,placeholder:String,color:UIColor,buttonText:String, textViewButtonOffset:CGFloat = 0){
        self.init(width:width,textViewButtonOffset:textViewButtonOffset)
        sendButton.setTitle(buttonText, for: UIControlState())
        sendButton.backgroundColor = color
        self.placeholder = placeholder
        textView.placeholder = placeholder
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpSendButton(){
        
        sendButton.setTitle("Send", for: UIControlState())
        sendButton.titleLabel?.font = Font.PageSmallBold()
        sendButton.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: UIControlState())
        sendButton.frame.size = CGSize(width: 60, height: TypingBar.Height)
        sendButton.center.y = frame.height/2
        sendButton.frame.origin.x = frame.width - sendButton.frame.width
        sendButton.backgroundColor = UIColor.orange
        addSubview(sendButton)
    }
    
    func resetToPlaceholder(){
        textView.placeholder = placeholder
        textView.text = nil
        
        let viewMaxY = frame.maxY
        frame.size.height = TypingBar.Height
        frame.origin.y = viewMaxY - frame.size.height
        textView.frame.size.height = frame.height - 2*elementOffset
        textView.center.y = frame.height/2
        sendButton.frame.origin.y = frame.height - sendButton.frame.height
        
    }
    
    func setUpTextView(){
        textView.frame.origin = CGPoint(x: elementOffset, y: elementOffset)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.frame.size.width = sendButton.frame.origin.x - 2*elementOffset - textViewButtonOffset
        textView.frame.size.height = frame.height - 2*elementOffset
        textView.delegate = self
        addSubview(textView)
        textView.textColor = UIColor.black
        textView.placeholder = placeholder
        textView.placeholderColor = globalGreyColor
        textView.backgroundColor = UIColor.white
        textView.returnKeyType = .done
        textView.layer.cornerRadius = 5
        //textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(white: 0.85, alpha: 1).cgColor
        textWidth = UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset).width
        textWidth -= 2.0 * textView.textContainer.lineFragmentPadding;
        
    }
    
    func setUpView(){
        backgroundColor = UIColor.white
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(white: 0.85, alpha: 1).cgColor
    }
    
    func sendButtonAction(){
        let viewMaxY = frame.maxY
        
        textView.text = nil
        textView.placeholder = placeholder
        
        frame.size.height = TypingBar.Height
        frame.origin.y = viewMaxY - frame.size.height
        textView.frame.size.height = frame.height - 2*elementOffset
        textView.center.y = frame.height/2
        sendButton.frame.origin.y = frame.height - sendButton.frame.height
        
    }
    
    func changeplaceholder(_ text:String){
        
        if textView.text.isEmpty || textView.text == placeholder{
            textView.placeholder = text
        }
        placeholder = text
    }
    
    func sizeOfString (_ string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width, height: DBL_MAX),
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSFontAttributeName: font],
                                                 context: nil).size
    }
    
    func checkIfCanPost(){
        
        if textView.hasText{
            sendButton.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
        }
        else{
            sendButton.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .normal)
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        let viewMaxY = frame.maxY
        
        let boundingRect = sizeOfString(textView.text, constrainedToWidth: Double(textWidth), font: textView.font!)
        let numberOfLines = boundingRect.height / textView.font!.lineHeight;
        
        
        textView.frame.size.height = textView.contentSize.height
        
        if numberOfLines == 1{
            textView.frame.size.height = TypingBar.Height - 2*elementOffset
        }
        frame.size.height = textView.frame.height + 2*elementOffset
        
        frame.origin.y = viewMaxY - frame.size.height
        
        textView.center.y = frame.height/2
        sendButton.frame.origin.y = frame.height - sendButton.frame.height
        textView.scrollRangeToVisible(textView.selectedRange)
        delegate?.textViewTextChanged()
        checkIfCanPost()
        
        
    }
    
    @objc(textView:shouldChangeTextInRange:replacementText:) func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            textView.endEditing(true)
            return false
        }
        return true
    }
    
    
    
    
}
