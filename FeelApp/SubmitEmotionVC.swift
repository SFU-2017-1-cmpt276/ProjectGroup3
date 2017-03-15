
//FeelApp
//This is the Submit emotion view controller. For the user to submit an emotion, along with optional text
///Programmers: Deepak and Carson
//Version 1: Created UI with no actions
//Version 2: Added submit action
//Version 3: Improved UI. Title bar font and color is depending on emotion.

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"


import UIKit
import FirebaseDatabase
import KMPlaceholderTextView

class SubmitEmotionVC: UIViewController {

    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    
    var textView = KMPlaceholderTextView()
    
    var submitButton = UIButton()
    
    var emotion:Emotion!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setUpTopView()
        setUpTextView()
    }

    func setUpTopView(){
        let size = CGSize(width: 50, height: 50)
        let inset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        topView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: 70))
        view.addSubview(topView)
        topView.backgroundColor = emotion.color
        
        
        backButton.frame.size = size
        backButton.setImage(#imageLiteral(resourceName: "leftArrowIcon.png"), for: .normal)
        backButton.contentEdgeInsets = inset
        
        topView.addSubview(backButton)
        backButton.changeToColor(UIColor.white)
        backButton.frame.origin.y = topView.frame.height - backButton.frame.height
        backButton.frame.origin.x = 0
        backButton.addTarget(self, action: #selector(SubmitEmotionVC.backAction), for: .touchUpInside)
    
        submitButton.frame.size = size
        submitButton.setImage(#imageLiteral(resourceName: "rightArrow2.png"), for: .normal)
        submitButton.contentEdgeInsets = inset
        topView.addSubview(submitButton)
        submitButton.changeToColor(UIColor.white)
        submitButton.frame.origin.y = topView.frame.height - submitButton.frame.height
        submitButton.frame.origin.x = topView.frame.width - submitButton.frame.width
        submitButton.addTarget(self, action: #selector(SubmitEmotionVC.submitEmotion), for: .touchUpInside)
        
        titleLabel.font = emotion.font
        titleLabel.text = emotion.name
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
        topView.addSubview(titleLabel)
    }
    
    func submitEmotion(){
        FIRDatabase.database().reference().child("Emotions").child(userUID).childByAutoId().setValue([
            "Type":emotion.name,
            "Text":textView.text,
            "Time":FIRServerValue.timestamp()
            ])
        dismiss(animated: true, completion: nil)
    }
    
    func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    func setUpTextView(){
        textView.frame.size = CGSize(width: view.frame.width, height: 100)
        view.addSubview(textView)
        textView.backgroundColor = UIColor.white
        textView.placeholder = "Why do you feel \(emotion.name.lowercased())?"
        textView.placeholderColor = globalGreyColor
        textView.placeholderFont = Font.PageBody()
        textView.textColor = emotion.color
        textView.font = Font.PageHeaderSmall()
        textView.frame.origin.y = topView.frame.height + 5
        
        textView.becomeFirstResponder()
        //Draw.createLineUnderView(textView, color: globalGreyColor)
        
    }

}
