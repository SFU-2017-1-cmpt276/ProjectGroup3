
import UIKit
import Firebase
import FirebaseAuth

class ChangeEmailVC: UIViewController {
    
    
    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    
    let emailTF = UITextField()
    let currentEmailTF = UITextField()
    let currentPasswordTF = UITextField()
    //let newEmailTF = UITextField()
    var submitButton = UIButton()
    
    let color = nowColor
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    //var credential = FIRAuth.c    //var user = firebase.auth().currentUser
    
    //set up the top bar and the text fields and the general view. set the username text field to be in editing mode when the VC first opens.
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ForgotPasswordVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        view.backgroundColor = UIColor.white
        
        setUpTopView()
        setUpTF()
        //setUpNewTF()
        setUpCurrentPasswordTF()
        setUpCurrentEmailTF()
        setUpButton()
        
        emailTF.becomeFirstResponder()
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let keyboardSize = ((notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        currentEmailTF.frame.origin.y = topView.frame.height + 30
        currentPasswordTF.frame.origin.y = currentEmailTF.frame.maxY-1
        emailTF.frame.origin.y = currentPasswordTF.frame.maxY-1
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
        titleLabel.text = "Change Email"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
        topView.addSubview(titleLabel)
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Error", message: "Please try again!", preferredStyle: .alert) // 7
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel) { (alerta: UIAlertAction!) -> Void in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(defaultAction) // 9
        self.present(alert, animated: true, completion:nil)
    }
    
    func submitAction(){
        let user = FIRAuth.auth()?.currentUser
        if emailTF.text == ""{return}
        if currentPasswordTF.text == ""{return}
        if currentEmailTF.text == ""{return}

        let credential = FIREmailPasswordAuthProvider.credential(withEmail: currentEmailTF.text!, password: currentPasswordTF.text!)
        
        user?.reauthenticate(with: credential) { error in
            if let error = error {
                self.showAlert()
            } else {
                user?.updateEmail(self.emailTF.text!, completion: {(error) in
                    self.submitButton.backgroundColor = UIColor.clear
                    self.submitButton.setTitleColor(UIColor.black, for: .normal)
                    self.submitButton.setTitle("Email changed!", for: .normal)
                    self.submitButton.isUserInteractionEnabled = false
                })
            }
        }
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
        //emailTF.layer.cornerRadius = 5
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
        emailTF.attributedPlaceholder = NSMutableAttributedString(string: "NEW EMAIL", attributes: [NSFontAttributeName:Font.PageBody()])
        emailTF.layer.borderWidth = 1
        emailTF.layer.borderColor = globalLightGrey.cgColor
        
        
    }
    
    func setUpCurrentEmailTF(){
        
        currentEmailTF.frame.size = CGSize(width: view.frame.width - 40, height: 60)
        view.addSubview(currentEmailTF)
        currentEmailTF.autocorrectionType = .no
        //currentEmailTF.layer.cornerRadius = 5
        currentEmailTF.clipsToBounds = true
        currentEmailTF.font = Font.PageBodyBold()
        currentEmailTF.center.y = view.frame.height/2
        currentEmailTF.center.x = view.frame.width/2
        currentEmailTF.backgroundColor = UIColor.red
        currentEmailTF.backgroundColor = UIColor(white: 1, alpha: 1)
        let someView = UIView()
        someView.frame = CGRect(x: 0, y: 0, width: 10, height: 60)
        currentEmailTF.leftView = someView
        currentEmailTF.leftViewMode = .always
        currentEmailTF.attributedPlaceholder = NSMutableAttributedString(string: "EMAIL", attributes: [NSFontAttributeName:Font.PageBody()])

        currentEmailTF.layer.borderWidth = 1
        currentEmailTF.layer.borderColor = globalLightGrey.cgColor
        
        
        
    }
    
    func setUpCurrentPasswordTF(){
        
        currentPasswordTF.frame.size = CGSize(width: view.frame.width - 40, height: 60)
        view.addSubview(currentPasswordTF)
        currentPasswordTF.autocorrectionType = .no
        //currentPasswordTF.layer.cornerRadius = 5
        currentPasswordTF.clipsToBounds = true
        currentPasswordTF.font = Font.PageBodyBold()
        currentPasswordTF.center.y = view.frame.height/2
        currentPasswordTF.center.x = view.frame.width/2
        currentPasswordTF.backgroundColor = UIColor.red
        currentPasswordTF.backgroundColor = UIColor(white: 1, alpha: 1)
        let someView = UIView()
        someView.frame = CGRect(x: 0, y: 0, width: 10, height: 60)
        currentPasswordTF.leftView = someView
        currentPasswordTF.leftViewMode = .always
        currentPasswordTF.attributedPlaceholder = NSMutableAttributedString(string: "PASSWORD", attributes: [NSFontAttributeName:Font.PageBody()])
        currentPasswordTF.layer.borderWidth = 1
        currentPasswordTF.layer.borderColor = globalLightGrey.cgColor
        
        
    }
    
    
    func setUpButton(){
        submitButton.frame.size.width = view.frame.width - 40
        submitButton.frame.size.height = 60
        submitButton.layer.cornerRadius = 8
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle("Change", for: .normal)
        submitButton.titleLabel?.font = Font.PageHeaderSmall()
        view.addSubview(submitButton)
        submitButton.backgroundColor = nowColor
        submitButton.center.x = view.frame.width/2
        submitButton.frame.origin.y = emailTF.frame.maxY + 40
        submitButton.layer.borderColor = UIColor.white.cgColor
        submitButton.addTarget(self, action: #selector(ChangeEmailVC.submitAction), for: .touchUpInside)

    }
    
    
}
