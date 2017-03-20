
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
    var postButton = UIButton()
    var bottomButtonHeight:CGFloat = 50
    var bottomButtonOffset:CGFloat = 10
    
    var emotion:Emotion!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(SubmitEmotionVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        setUpTopView()
        setUpTextView()
        setUpBottomButtons()
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
    
    func postAndSubmit(){
        
        FIRDatabase.database().reference().child("Posts").childByAutoId().setValue([
            "Emotion":[
                "Type":emotion.name,
                "Text":textView.text,
                "Time":FIRServerValue.timestamp()
            ],
            "Sender ID":userUID,
            "Sender Alias":GlobalData.You.alias
            
            ])
        
        submitEmotion()
    }
    
    func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    func setUpTextView(){
        textView.frame.origin.y = topView.frame.height + 5
        textView.frame.size = CGSize(width: view.frame.width - 20, height: 100)
        textView.center.x = view.frame.width/2
        view.addSubview(textView)
        textView.backgroundColor = UIColor.white
        textView.placeholder = "Why do you feel \(emotion.name.lowercased())?"
        textView.placeholderColor = globalGreyColor
        textView.placeholderFont = Font.PageBody()
        textView.textColor = emotion.color
        textView.font = Font.PageHeaderSmall()
        textView.tintColor = emotion.color
       
        textView.becomeFirstResponder()
    }
    
    func setUpBottomButtons(){
        for button in [submitButton,postButton]{
            view.addSubview(button)
            button.frame.size.height = bottomButtonHeight
            button.frame.size.width = view.frame.width/2 - 2*bottomButtonOffset
            button.backgroundColor = UIColor.white
            button.setTitle("Post", for: .normal)
            button.titleLabel?.font = Font.PageBodyBold()
            button.layer.cornerRadius = bottomButtonHeight/2
            button.clipsToBounds = true
            button.layer.borderWidth = 3
            button.layer.borderColor = emotion.color.cgColor
            button.setTitleColor(emotion.color, for: .normal)
        }
        submitButton.addTarget(self, action: #selector(SubmitEmotionVC.submitEmotion), for: .touchUpInside)
        postButton.addTarget(self, action: #selector(SubmitEmotionVC.postAndSubmit), for: .touchUpInside)

        postButton.backgroundColor = emotion.color
        postButton.setTitleColor(UIColor.white, for: .normal)
        
        postButton.setTitle("Post and Share", for: .normal)
        submitButton.frame.origin.x = bottomButtonOffset
        postButton.frame.origin.x = view.frame.width/2 + bottomButtonOffset
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let keyboardSize = ((notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        textView.frame.size.height = view.frame.height - keyboardSize!.height - textView.frame.origin.y - bottomButtonHeight
        for button in [submitButton,postButton]{
            button.frame.origin.y = textView.frame.maxY - bottomButtonOffset
        }
        
        
        
    }

}
