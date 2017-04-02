//FeelApp
//This is the login view controller. For the user to log into the app (assuming they have signed up previously).
///Programmers: Deepak and Carson
//Version 1: Created UI with no actions.
//Version 2: Connected to Firebase. Now logs in if you input the correct email and password.
//Version 3: Improved UI. Changed placeholder color and background color.
//Version 4: fixed keyboard bug (keyboard wasnt closing once opened)

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"

import UIKit
import FirebaseAuth
import FirebaseDatabase
import UIKit



class LoginVC: UIViewController {

    let usernameTF = UITextField()
    let passwordTF = UITextField()
    
    let loginButton = UIButton()
    let signupButton = UIButton()
    
    let color = nowColor
    
    let logo = UIImageView()
    
    let forgotPassword = UIButton()
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    var dismissKeyboardRec:UITapGestureRecognizer!
    
    
    //set up logo, text fields, and buttons.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = color
        setUpLogo()
        
        
        
        
        
        if FIRAuth.auth()?.currentUser != nil{
            FIRDatabase.database().reference().child("Users").child(userUID).observeSingleEvent(of: .value, with: {snapshot in
                GlobalData.You.alias = snapshot.value! as? String ?? ""
                let vc = HomeVC()
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            })
        }
        else{
        setUpTFs()
        setUpLoginButton()
        setUpSignupButton()
        setUpForgotPassword()
        
        //set up the view
        view.backgroundColor = color
        
        //add a tap gesture recognizer to the view, so that if the keyboard is up and the user taps the view, the keyboard is dismissed
        dismissKeyboardRec = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        dismissKeyboardRec.isEnabled = false
        view.addGestureRecognizer(dismissKeyboardRec)
        
        //add a notification for when the keyboard is shown, so that the dismissKeyboardRec can be activated
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //set the starting value for the username and password with an account thats already been created. Not for finished version but easy to log in.
        usernameTF.text = "ckl41@sfu.ca"
        passwordTF.text = "123456"
        
        }
    }
    
    //when the view is tapped and the keyboard is up, end editing for all text fields and disable the gesture recognzer
    func dismissKeyboard(){
        for tf in [usernameTF,passwordTF]{
            tf.endEditing(true)
        }
        dismissKeyboardRec.isEnabled = false
    }
    
    //when keyboard pops up, enable the gesture recognizer, so that when the user taps on the view the keyboard is dismissed.
    func keyboardWillShow() {
        dismissKeyboardRec.isEnabled = true
    }

    
    //set up the logo. frame, image, color
    func setUpLogo(){
        logo.frame.size = CGSize(width: 100, height: 100)
        view.addSubview(logo)
        logo.image = #imageLiteral(resourceName: "Main Logo.png")
        logo.center.x = view.frame.width/2
        logo.frame.origin.y = view.frame.height/2 - logo.frame.height - 40 - 60
        logo.changeToColor(UIColor.white)
    }
    
    //set up text fields. Format and other specifications. Placeholders and position.
    func setUpTFs(){
        
        for tf in [usernameTF,passwordTF]{
            tf.frame.size = CGSize(width: view.frame.width - 40, height: 60)
            view.addSubview(tf)
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
        passwordTF.roundedBottomText()
        
         usernameTF.attributedPlaceholder = NSMutableAttributedString(string: "EMAIL", attributes: [NSFontAttributeName:Font.PageBody(),NSForegroundColorAttributeName:globalGreyColor])
         passwordTF.attributedPlaceholder = NSMutableAttributedString(string: "PASSWORD", attributes: [NSFontAttributeName:Font.PageBody(),NSForegroundColorAttributeName:globalGreyColor])
        usernameTF.frame.origin.y = 100
        passwordTF.frame.origin.y = usernameTF.frame.maxY
        passwordTF.isSecureTextEntry = true
        
        usernameTF.frame.origin.y = view.frame.height/2 - usernameTF.frame.height
        passwordTF.frame.origin.y = view.frame.height/2
        
        
        
        Draw.createLineUnderView(usernameTF, color: globalLightGrey)
        
    }
    
    //set up the login button. format. Add an action to the button
    func setUpLoginButton(){
        loginButton.frame.size.width = view.frame.width - 40
        loginButton.frame.size.height = 60
        loginButton.layer.cornerRadius = 8
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.setTitle("LOG IN", for: .normal)
        loginButton.titleLabel?.font = Font.PageHeaderSmall()
        view.addSubview(loginButton)
        loginButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
        loginButton.center.x = view.frame.width/2
        loginButton.frame.origin.y = passwordTF.frame.maxY + 40
        //loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.addTarget(self, action: #selector(LoginVC.loginAction), for: .touchUpInside)
    }
    
    //set up the sign up button. format. Add an action to the button
    func setUpSignupButton(){
        signupButton.frame.size.width = view.frame.width - 40
        signupButton.frame.size.height = 60
        signupButton.layer.cornerRadius = 8
        signupButton.setTitleColor(UIColor.white, for: .normal)
        signupButton.setTitle("SIGN UP", for: .normal)
        signupButton.titleLabel?.font = Font.PageHeaderSmall()
        view.addSubview(signupButton)
        signupButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
        signupButton.center.x = view.frame.width/2
        signupButton.frame.origin.y = passwordTF.frame.maxY + 40
       // signupButton.layer.borderWidth = 2
        signupButton.layer.borderColor = UIColor.white.cgColor
        signupButton.addTarget(self, action: #selector(LoginVC.toSignUp), for: .touchUpInside)
        signupButton.frame.origin.y = loginButton.frame.maxY + 15
    }
    
    //function that is performed when the login button is clicked. If username or password text fields are empty, dont do anything. Else, try to log in. If log in is successful, go to the HomeVC. else, do nothing.
    func loginAction(){
        
        if usernameTF.text == "" || passwordTF.text == ""{return}

        FIRAuth.auth()?.signIn(withEmail: usernameTF.text!, password: passwordTF.text!) { (user, error) in
            
            if error == nil && user != nil{
                FIRDatabase.database().reference().child("Users").child(userUID).observeSingleEvent(of: .value, with: {snapshot in
                    GlobalData.You.alias = snapshot.value! as? String ?? ""
                    let vc = HomeVC()
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true, completion: nil)
                })
                

            }
        }
        
       
    }
    
    //function called by sign up button. go to sign up vc.
    func toSignUp(){
        let vc = SignupVC()
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    func toForgotPassword(){
        let vc = ForgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    //set up forgot password button format. No action yet. 
    func setUpForgotPassword(){
        forgotPassword.setTitle("Forgot password?", for: .normal)
        view.addSubview(forgotPassword)
        forgotPassword.titleLabel?.font = Font.PageBodyBold()
        forgotPassword.sizeToFit()
        forgotPassword.center.x = view.frame.width/2
        forgotPassword.frame.origin.y = signupButton.frame.maxY + 15
        forgotPassword.addTarget(self, action: #selector(LoginVC.toForgotPassword), for: .touchUpInside)
    }

}
