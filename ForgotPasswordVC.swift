
import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {
    
    
    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    
    let emailTF = UITextField()
    var submitButton = UIButton()
    
    let color = nowColor
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //set up the top bar and the text fields and the general view. set the username text field to be in editing mode when the VC first opens.
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ForgotPasswordVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        view.backgroundColor = color
        
        setUpTopView()
        setUpTF()
        setUpButton()
        
        emailTF.becomeFirstResponder()
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let keyboardSize = ((notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        emailTF.center.y = ((view.frame.height - keyboardSize!.height) + topView.frame.height)/2 - 40
        submitButton.frame.origin.y = emailTF.frame.maxY + 20
        
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
        backButton.addTarget(self, action: #selector(ForgotPasswordVC.backAction), for: .touchUpInside)
        
        titleLabel.font = Font.PageHeaderSmall()
        titleLabel.text = "Forgot Password"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
        topView.addSubview(titleLabel)
    }
    func submitAction(){
        
        if emailTF.text == ""{return}
        FIRAuth.auth()?.sendPasswordReset(withEmail: emailTF.text!, completion: {(error) in
            self.submitButton.backgroundColor = UIColor.clear
            self.submitButton.setTitle("Email Sent!", for: .normal)
            
            })
    }
    
    //action called when back button is clicked. dismiss view controller.
    func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    //set up the text fields. Their formatitng, position, placeholders, and other attributes
    //Round the top the the username text field and the bottom of the alias text field.
    func setUpTF(){
        
        emailTF.frame.size = CGSize(width: view.frame.width - 40, height: 60)
        view.addSubview(emailTF)
        emailTF.autocorrectionType = .no
        emailTF.layer.cornerRadius = 5
        emailTF.clipsToBounds = true
        emailTF.font = Font.PageBodyBold()
        emailTF.center.y = view.frame.height/2
        emailTF.center.x = view.frame.width/2
        emailTF.backgroundColor = UIColor.red
        emailTF.backgroundColor = UIColor(white: 1, alpha: 1)
        let someView = UIView()
        someView.frame = CGRect(x: 0, y: 0, width: 10, height: 60)
        emailTF.leftView = someView
        emailTF.leftViewMode = .always
        emailTF.attributedPlaceholder = NSMutableAttributedString(string: "EMAIL", attributes: [NSFontAttributeName:Font.PageBody()])
        Draw.createLineUnderView(emailTF, color: globalLightGrey)
    }
    
    func setUpButton(){
        submitButton.frame.size.width = view.frame.width - 40
        submitButton.frame.size.height = 60
        submitButton.layer.cornerRadius = 8
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle("SEND", for: .normal)
        submitButton.titleLabel?.font = Font.PageHeaderSmall()
        view.addSubview(submitButton)
        submitButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
        submitButton.center.x = view.frame.width/2
        submitButton.frame.origin.y = emailTF.frame.maxY + 40
        submitButton.layer.borderColor = UIColor.white.cgColor
        submitButton.addTarget(self, action: #selector(ForgotPasswordVC.submitAction), for: .touchUpInside)

    }
    
    
}
