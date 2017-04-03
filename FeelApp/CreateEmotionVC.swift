
//FeelApp
//This is the Submit emotion view controller. For the user to submit an emotion, along with optional text
///Programmers: Deepak and Carson
//Version 1: Created UI with no actions
//Version 2: Added submit action
//Version 3: Improved UI. Title bar font and color is depending on emotion.
//Version 4: Made the squares into rounded rectangles (added corner radius)

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"


import UIKit
import FirebaseDatabase
import ColorSlider

protocol CreateEmotionDelegate{
    func emotionCreated(emotion:Emotion)->Void
}
class CreateEmotionVC: UIViewController {
    
    var delegate:CreateEmotionDelegate?
    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    
    var emotionTF = UITextField()
    
    var submitButton = UIButton()
    var bottomButtonHeight:CGFloat = 50
    var bottomButtonOffset:CGFloat = 10
    
    var selectedColor = UIColor.black

    let colorSlider = ColorSlider()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    // set up the top bar, text view, and bottom buttons
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        //get notification for when keyboard is shown
        NotificationCenter.default.addObserver(self, selector: #selector(CreateEmotionVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        setUpTopView()
        setUpEmotionTF()
        setUpBottomButtons()
        setUpColorSlider()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emotionTF.becomeFirstResponder()
    }
    
    //Set up the top bar. The view, title label, and the history/link button on the top right/left.
    func setUpTopView(){
        let size = CGSize(width: 50, height: 50)
        let inset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        topView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: 70))
        view.addSubview(topView)
        topView.backgroundColor = nowColor
        
        
        backButton.frame.size = size
        backButton.setImage(#imageLiteral(resourceName: "leftArrowIcon.png"), for: .normal)
        backButton.contentEdgeInsets = inset
        
        topView.addSubview(backButton)
        backButton.changeToColor(UIColor.white)
        backButton.frame.origin.y = topView.frame.height - backButton.frame.height
        backButton.frame.origin.x = 0
        backButton.addTarget(self, action: #selector(CreateEmotionVC.backAction), for: .touchUpInside)
        
        titleLabel.font = Font.PageHeaderSmall()
        titleLabel.text = "New Emotion"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
        topView.addSubview(titleLabel)
    }
    
    //action when back button is clicked. dismiss the view controller/
    func backAction(){
        emotionTF.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func setUpColorSlider(){
        
        colorSlider.frame.size = CGSize(width: view.frame.width - 40, height: 30)
        view.addSubview(colorSlider)
        colorSlider.layer.borderWidth = 0
        colorSlider.orientation = .horizontal
        colorSlider.center.x = view.frame.width/2
        colorSlider.frame.origin.y = emotionTF.frame.maxY + 10
        colorSlider.previewEnabled = true
        colorSlider.addTarget(self, action: #selector(CreateEmotionVC.colorChanged), for: .valueChanged)
        colorSlider.borderColor = UIColor.white
        colorSlider.setsCornerRadiusAutomatically = false
        colorSlider.layer.cornerRadius = 5
        
    }
    
    func colorChanged(){
       // topView.backgroundColor = colorSlider.color
        //submitButton.backgroundColor = colorSlider.color
        emotionTF.textColor = colorSlider.color
        emotionTF.layer.borderColor = colorSlider.color.cgColor
        submitButton.backgroundColor = colorSlider.color
        
    }
    
    func setUpEmotionTF(){
        emotionTF.frame.size = CGSize(width: view.frame.width - 40, height: 60)
        view.addSubview(emotionTF)
        emotionTF.autocorrectionType = .no
        emotionTF.layer.cornerRadius = 5
        emotionTF.clipsToBounds = true
        emotionTF.font = Font.PageHeaderSmall()
        emotionTF.frame.origin.y = topView.frame.height + 10
        emotionTF.center.x = view.frame.width/2
        emotionTF.backgroundColor = UIColor(white: 1, alpha: 1)
        emotionTF.textAlignment = .center
        //emotionTF.attributedPlaceholder = NSMutableAttributedString(string: "NAME", attributes: [NSFontAttributeName:Font.PageBody()])
        emotionTF.layer.borderWidth = 3
        emotionTF.layer.borderColor = UIColor.black.cgColor
        emotionTF.tintColor = UIColor.black
    }
    
    
    //set up the bottom buttons. frame, title, actions, formatting
    func setUpBottomButtons(){
        for button in [submitButton]{
            view.addSubview(button)
            button.frame.size.height = bottomButtonHeight
            button.frame.size.width = view.frame.width - 2*bottomButtonOffset
            button.backgroundColor = UIColor.white
            button.setTitle("Post", for: .normal)
            button.titleLabel?.font = Font.PageHeaderSmall()
            button.layer.cornerRadius = bottomButtonHeight/2
            button.clipsToBounds = true
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = nowColor
        }
        submitButton.addTarget(self, action: #selector(CreateEmotionVC.createEmotion), for: .touchUpInside)
        submitButton.center.x = view.frame.width/2
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Emotion already exists", message: "Please try again!", preferredStyle: .alert) // 7
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel) { (alerta: UIAlertAction!) -> Void in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(defaultAction) // 9
        self.present(alert, animated: true, completion:nil)
    }

    
    func createEmotion(){
        if emotionTF.text == ""{return}
        var alreadyThere = false
        for emotion in Emotion.getAll(){
            if emotion.name.lowercased() == emotionTF.text{
                showAlert()
                var alreadyThere = true
                break
            }
        }
        if alreadyThere{return}
        
        FIRDatabase.database().reference().child("Custom Emotions").child(userUID).observeSingleEvent(of: .value, with: {snapshot in
            
            let dict = snapshot.value! as? [String:AnyObject] ?? [:]
            
            var alreadyThere = false
            for(id,emotionDict) in dict{
                let emotion = Emotion()
                emotion.name = emotionDict["Name"] as? String ?? ""
                if emotion.name.lowercased() == self.emotionTF.text!.lowercased(){
                    alreadyThere = true
                    break
                }
                
            }
            
            if alreadyThere{
                self.showAlert()
            }
            else{
                let color = CIColor(color: self.colorSlider.color)
                 FIRDatabase.database().reference().child("Custom Emotions").child(userUID).childByAutoId().setValue([
                    "Color":[
                        "Blue":color.blue,
                        "Red":color.red,
                        "Green":color.green
                    ],
                    "Name":self.emotionTF.text!
                
                    ])
                let emotion = Emotion()
                emotion.color = self.colorSlider.color
                emotion.name = self.emotionTF.text!
                emotion.custom = true
                emotion.font = Font.CustomEmotionFont()
                self.delegate?.emotionCreated(emotion: emotion)
                self.dismiss(animated: true, completion: nil)
            }
            
        })

    }
    
    //when the keyboard is shown, position the bottom buttons so that they are just above the keyboard. The resize the text view accordingly.
    func keyboardWillShow(_ notification: Notification) {
        let keyboardSize = ((notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        for button in [submitButton]{
            button.frame.origin.y = view.frame.height - keyboardSize!.height - button.frame.height - bottomButtonOffset
        }
        let centerY = (submitButton.frame.origin.y + topView.frame.height)/2
        emotionTF.frame.origin.y = centerY - 5 - emotionTF.frame.height
        colorSlider.frame.origin.y = 5 + centerY
        //colorSlider.frame.origin.y = submitButton.frame.origin.y - colorSlider.frame.height - 20

    }
    
}
