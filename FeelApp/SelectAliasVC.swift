//FeelApp
//This is the Sign Up view controller. For the user to sign up to FeelApp
///Programmers: Deepak and Carson
//Version 1: Created UI with no actions
//Version 2: Add Sign Up action
//Version 3: Improved UI. Added background colors and changed placeholder colors.
//Version 4: fixed keyboard bug (keyboard wasnt closing once opened)

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"



import UIKit
import Firebase

class SelectAliasVC: UIViewController {
    
    
    var backButton = UIButton()
    var signupButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    
    let aliasTF = UITextField()
    var blurb = UILabel()
    
    let color = nowColor
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //set up the top bar and the text fields and the general view. set the username text field to be in editing mode when the VC first opens.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        view.backgroundColor = color
        
        setUpTopView()
        setUpTFs()
        setUpSignUpButton()
        setUpBlurb()
        
        aliasTF.becomeFirstResponder()
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
        backButton.addTarget(self, action: #selector(SelectAliasVC.backAction), for: .touchUpInside)
        backButton.isHidden = true
        
        titleLabel.font = Font.PageHeaderSmall()
        titleLabel.text = "Sign Up"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
       // topView.addSubview(titleLabel)
    }
    
    func setUpBlurb(){
        let string = "Your account has been created! Please choose an alias. It will be your name in the social feed section of FeelApp"
        blurb.frame.size.width = view.frame.width - 30
        blurb.preferredMaxLayoutWidth = view.frame.width - 30
        view.addSubview(blurb)
        blurb.numberOfLines = 0
        blurb.font = Font.PageBodyBold()
        blurb.textColor = UIColor.white
        blurb.text = string
        blurb.sizeToFit()
        blurb.center.x = view.frame.width/2
        blurb.frame.origin.y = 20
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let keyboardSize = ((notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        aliasTF.center.y = (view.frame.height - keyboardSize!.height)/2
        signupButton.frame.origin.y = aliasTF.frame.maxY + 15
        //blurb.frame.origin.y = aliasTF.frame.origin.y - blurb.frame.height - 30
    }
    
    //action when the submit button is pressed. If any text field is empty, dont do anything. If there is an error, dont do anything. Otherwise, create an account with the information provided, and transition to HomeVC
    
    func showAlert(text:String){
        aliasTF.text = ""
        let alert = UIAlertController(title: text, message: "Please try again!", preferredStyle: .alert) // 7
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel) { (alerta: UIAlertAction!) -> Void in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(defaultAction) // 9
        self.present(alert, animated: true, completion:nil)
    }
    func submitAction(){
        
        if aliasTF.text == ""{return}
        FIRDatabase.database().reference().child("Users").observeSingleEvent(of: .value, with: {snapshot in
            let dict = snapshot.value! as? [String:String] ?? [:]
            
            var aliasWorks = true
            for (_,alias) in dict{
                if alias.lowercased() == self.aliasTF.text!.lowercased(){
                    self.showAlert(text: "This alias has already been taken")
                    aliasWorks = false
                    break
                }
            }
            
            if aliasWorks{
                FIRDatabase.database().reference().child("Users").child(userUID).setValue(self.aliasTF.text!)
                GlobalData.You.id = userUID
                GlobalData.You.alias = self.aliasTF.text!
                let vc = HomeVC()
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        })
    }

    //action called when back button is clicked. dismiss view controller.
    func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    //set up the text fields. Their formatitng, position, placeholders, and other attributes
    //Round the top the the username text field and the bottom of the alias text field.
    func setUpTFs(){
        
        for tf in [aliasTF]{
            tf.frame.size = CGSize(width: view.frame.width - 40, height: 60)
            view.addSubview(tf)
            tf.autocorrectionType = .no
            tf.font = Font.PageBodyBold()
            tf.center.x = view.frame.width/2
            tf.backgroundColor = UIColor.red
            tf.backgroundColor = UIColor(white: 1, alpha: 1)
            tf.attributedPlaceholder = NSMutableAttributedString(string: "EMAIL", attributes: [NSFontAttributeName:Font.PageBody(),NSForegroundColorAttributeName:globalGreyColor])
            let someView = UIView()
            someView.frame = CGRect(x: 0, y: 0, width: 10, height: 60)
            tf.leftView = someView
            tf.leftViewMode = .always
            tf.layer.cornerRadius = 6
            tf.clipsToBounds = true
        }
        
        aliasTF.attributedPlaceholder = NSMutableAttributedString(string: "ALIAS", attributes: [NSFontAttributeName:Font.PageBody(),NSForegroundColorAttributeName:globalGreyColor])
        aliasTF.frame.origin.y = topView.frame.height + 30
        Draw.createLineUnderView(aliasTF, color: globalLightGrey)
        
    }
    
    func setUpSignUpButton(){
        signupButton.frame.size.width = view.frame.width - 40
        signupButton.frame.size.height = 60
        signupButton.layer.cornerRadius = 8
        signupButton.setTitleColor(UIColor.white, for: .normal)
        signupButton.setTitle("SUBMIT", for: .normal)
        signupButton.titleLabel?.font = Font.PageHeaderSmall()
        view.addSubview(signupButton)
        signupButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
        signupButton.center.x = view.frame.width/2
        signupButton.frame.origin.y = aliasTF.frame.maxY + 40
        // signupButton.layer.borderWidth = 2
        signupButton.layer.borderColor = UIColor.white.cgColor
        signupButton.addTarget(self, action: #selector(SelectAliasVC.submitAction), for: .touchUpInside)
        signupButton.frame.origin.y = aliasTF.frame.maxY + 15
    }
}
