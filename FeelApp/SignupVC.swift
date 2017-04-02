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

class SignupVC: UIViewController {
    
    
    var backButton = UIButton()
    var submitButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    
    let usernameTF = UITextField()
    let passwordTF = UITextField()
    let password2TF = UITextField()
    let aliasTF = UITextField()
    
    let color = nowColor
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //set up the top bar and the text fields and the general view. set the username text field to be in editing mode when the VC first opens. 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = color

        setUpTopView()
        setUpTFs()
        
        usernameTF.becomeFirstResponder()
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
        backButton.addTarget(self, action: #selector(SignupVC.backAction), for: .touchUpInside)
        
        submitButton.frame.size = CGSize(width: 40, height: 40)
        submitButton.setImage(#imageLiteral(resourceName: "rightArrow2.png"), for: .normal)
        submitButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        topView.addSubview(submitButton)
        submitButton.changeToColor(nowColor)
        submitButton.backgroundColor = UIColor.white
        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius = submitButton.frame.height/2
        submitButton.frame.origin.y = topView.frame.height - submitButton.frame.height
        submitButton.frame.origin.x = topView.frame.width - submitButton.frame.width - 10
        submitButton.addTarget(self, action: #selector(SignupVC.submitAction), for: .touchUpInside)
        
        titleLabel.font = Font.PageHeaderSmall()
        titleLabel.text = "Sign Up"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
        topView.addSubview(titleLabel)
    }
    
    //action when the submit button is pressed. If any text field is empty, dont do anything. If there is an error, dont do anything. Otherwise, create an account with the information provided, and transition to HomeVC
    func submitAction(){
        
        if usernameTF.text == "" || passwordTF.text == "" || aliasTF.text == ""{return}
        FIRAuth.auth()?.createUser(withEmail: usernameTF.text!, password: passwordTF.text!) { (user, error) in
            if error == nil && user != nil{
                
                //set the alias the user has inputted to firebase.
                FIRDatabase.database().reference().child("Users").child(user!.uid).setValue(self.aliasTF.text!)
                
                //add this information to the global you variable.
                GlobalData.You.alias = self.aliasTF.text!
                
                GlobalData.You.id = user!.uid
                let vc = HomeVC()
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    //action called when back button is clicked. dismiss view controller.
    func backAction(){
        dismiss(animated: true, completion: nil)
    }

    //set up the text fields. Their formatitng, position, placeholders, and other attributes
    //Round the top the the username text field and the bottom of the alias text field.
    func setUpTFs(){
        
        for tf in [usernameTF,passwordTF,password2TF, aliasTF]{
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
        }
        usernameTF.roundedTopText()
        aliasTF.roundedBottomText()
        
        usernameTF.attributedPlaceholder = NSMutableAttributedString(string: "EMAIL", attributes: [NSFontAttributeName:Font.PageBody(),NSForegroundColorAttributeName:globalGreyColor])
        passwordTF.attributedPlaceholder = NSMutableAttributedString(string: "PASSWORD", attributes: [NSFontAttributeName:Font.PageBody(),NSForegroundColorAttributeName:globalGreyColor])
        password2TF.attributedPlaceholder = NSMutableAttributedString(string: "CONFIRM PASSWORD", attributes: [NSFontAttributeName:Font.PageBody(),NSForegroundColorAttributeName:globalGreyColor])
        aliasTF.attributedPlaceholder = NSMutableAttributedString(string: "ALIAS", attributes: [NSFontAttributeName:Font.PageBody(),NSForegroundColorAttributeName:globalGreyColor])
        
        aliasTF.frame.origin.y = passwordTF.frame.maxY
        
        passwordTF.isSecureTextEntry = true
        password2TF.isSecureTextEntry = true
        
        usernameTF.frame.origin.y = topView.frame.maxY + 20
        passwordTF.frame.origin.y = usernameTF.frame.maxY
        password2TF.frame.origin.y = passwordTF.frame.maxY
        aliasTF.frame.origin.y = password2TF.frame.maxY
        
        Draw.createLineUnderView(usernameTF, color: globalLightGrey)
        Draw.createLineUnderView(passwordTF, color: globalLightGrey)
        Draw.createLineUnderView(password2TF, color: globalLightGrey)
        
    }
}
