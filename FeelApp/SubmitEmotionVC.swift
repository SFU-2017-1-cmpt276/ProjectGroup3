
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
import KMPlaceholderTextView
import FirebaseStorage

class SubmitEmotionVC: UIViewController,CameraVCDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoViewerVCDelegate {

    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    
    var textView = KMPlaceholderTextView()
    
    var postAlso = false
    var submitButton = UIButton()
    var postButton = UIButton()
    var bottomButtonHeight:CGFloat = 50
    var bottomButtonOffset:CGFloat = 10
    
    var emotion:Emotion!
    
    var photos:[UIImage] = []
    
    var numberOfPhotosButton = UIButton()
    
    var photoButton = UIButton()
    var cameraButton = UIButton()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    // set up the top bar, text view, and bottom buttons
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        //get notification for when keyboard is shown
        NotificationCenter.default.addObserver(self, selector: #selector(SubmitEmotionVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        setUpTopView()
        setUpTextView()
        setUpPhotoStuff()
        setUpBottomButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }

    //Set up the top bar. The view, title label, and the history/link button on the top right/left.
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
    
    func photoAccepted(photo: UIImage) {
        photos.append(photo)
        resetPhotoNumberButton()
    }
    
    func resetPhotoNumberButton(){
         numberOfPhotosButton.setTitle("\(photos.count) photos", for: .normal)
        if photos.count == 0{numberOfPhotosButton.isHidden = true}
        else{numberOfPhotosButton.isHidden = false}
        numberOfPhotosButton.sizeToFit()
    }
    
    //action when the submit button is clicked. Add the data to your own emotion data in firebase and dismiss the view controller.
    func submitEmotion(sender:UIButton){
        
        let emotionID =  FIRDatabase.database().reference().childByAutoId().key
        
        
        let dict = NSMutableDictionary()

        dict.setValue(emotion.name,forKey:"Type")
        dict.setValue(textView.text,forKey:"Text")
        dict.setValue(FIRServerValue.timestamp(),forKey:"Time")
        let photoDict = NSMutableDictionary()
        var photoKeyArray:[String] = []
        for photo in photos{
            let photoKey = FIRDatabase.database().reference().childByAutoId().key
            photoKeyArray.append(photoKey)
            photoDict.setValue(FIRServerValue.timestamp(), forKey:  photoKey)
        }
        if photos.count != 0{
        dict.setValue(photoDict, forKey: "Photos")
        }
        FIRDatabase.database().reference().child("Emotions").child(userUID).child(emotionID).setValue(dict)
        
        
        for i in 0 ..< photos.count{
            let storageRef = GlobalData.getPhotosStorageRef().child("/\(emotionID)").child("/\(photoKeyArray[i]).jpg")
            
            let data = UIImageJPEGRepresentation(photos[i], 0.3)!
            storageRef.put(data)
        }
        
        if sender == postButton{
            if photos.count == 0{
            post(postID: emotionID, photoDict: nil)
            }
            else{
                post(postID: emotionID, photoDict: photoDict)
            }
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    //action when the post button is clicked. Add data to the newsfeed data in firebase.
    func post(postID:String,photoDict:NSMutableDictionary?){
        
        let dict = NSMutableDictionary()
        dict.setValue([
            "Type":emotion.name,
            "Text":textView.text,
            "Time":FIRServerValue.timestamp()
            ],forKey:"Emotion")
        dict.setValue(userUID,forKey:"Sender ID")
        dict.setValue(GlobalData.You.alias,forKey:"Sender Alias")
        
        if photoDict != nil{
            dict.setValue(photoDict!, forKey: "Photos")
        }
        
        FIRDatabase.database().reference().child("Posts").child(postID).setValue(dict)
    }
    
    func getCurrentPhotos(photos: [UIImage]) {
        self.photos = photos
        resetPhotoNumberButton()
    }
    
    func setUpPhotoStuff(){
        photoButton.frame.size = CGSize(width: 45, height: 45)
        photoButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        view.addSubview(photoButton)
        photoButton.setImage(#imageLiteral(resourceName: "photoIcon2"), for: .normal)
        photoButton.changeToColor(emotion.color)
        photoButton.backgroundColor = UIColor.white
        photoButton.clipsToBounds = true
        photoButton.layer.cornerRadius = photoButton.frame.width/2
        photoButton.frame.origin.x = view.frame.width - bottomButtonOffset - photoButton.frame.width
        photoButton.addTarget(self, action: #selector(SubmitEmotionVC.photoButtonAction), for: .touchUpInside)
        
        cameraButton.frame.size = CGSize(width: 45, height: 45)
        cameraButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        view.addSubview(cameraButton)
        cameraButton.setImage(#imageLiteral(resourceName: "cameraIcon4.png"), for: .normal)
        cameraButton.changeToColor(emotion.color)
        cameraButton.backgroundColor = UIColor.white
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = photoButton.frame.width/2
        cameraButton.frame.origin.x = photoButton.frame.origin.x - bottomButtonOffset - cameraButton.frame.width
        cameraButton.addTarget(self, action: #selector(SubmitEmotionVC.showCameraVC), for: .touchUpInside)
        
        numberOfPhotosButton.titleLabel?.font = Font.PageSmallBold()
        numberOfPhotosButton.setTitleColor(emotion.color, for: .normal)
        view.addSubview(numberOfPhotosButton)
        numberOfPhotosButton.setTitle("2 photos", for: .normal)
        numberOfPhotosButton.isHidden = true
        numberOfPhotosButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)
        numberOfPhotosButton.sizeToFit()
        numberOfPhotosButton.layer.cornerRadius = numberOfPhotosButton.frame.height/2
        numberOfPhotosButton.layer.borderWidth = 2
        numberOfPhotosButton.layer.borderColor = emotion.color.cgColor
        numberOfPhotosButton.frame.origin.x = cameraButton.frame.origin.x - bottomButtonOffset - numberOfPhotosButton.frame.width - 5
        numberOfPhotosButton.addTarget(self, action: #selector(SubmitEmotionVC.showPhotoViewerVC), for: .touchUpInside)
        
    }

    func showPhotoViewerVC(){
        let vc = PhotoViewerVC()
        vc.photos = photos
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func photoButtonAction() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        photos.append(image)
        self.dismiss(animated: false, completion: nil)
        resetPhotoNumberButton()
    }

    
    func showCameraVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "camera") as! CameraVC
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    

   
    
    //action when back button is clicked. dismiss the view controller/
    func backAction(){
        textView.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    //set up the text view. set the placeholder, formatting, frame. Then put it in editing mode when the view controller is first opened
    func setUpTextView(){
        textView.frame.origin.y = topView.frame.height + 5
        textView.frame.size = CGSize(width: view.frame.width - 20, height: 100)
        textView.center.x = view.frame.width/2
        view.addSubview(textView)
        textView.backgroundColor = UIColor.white
        textView.placeholder = "Why do you feel \(emotion.name.lowercased())?"
        textView.placeholderColor = globalGreyColor
        textView.placeholderFont = Font.PageBody()
        textView.textColor = UIColor.black
        textView.font = Font.PageHeaderSmall()
        textView.tintColor = emotion.color
    }
    
    //set up the bottom buttons. frame, title, actions, formatting
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
        submitButton.addTarget(self, action: #selector(SubmitEmotionVC.submitEmotion(sender:)), for: .touchUpInside)
        postButton.addTarget(self, action: #selector(SubmitEmotionVC.submitEmotion(sender:)), for: .touchUpInside)

        postButton.backgroundColor = emotion.color
        postButton.setTitleColor(UIColor.white, for: .normal)
        
        postButton.setTitle("Post and Share", for: .normal)
        submitButton.frame.origin.x = bottomButtonOffset
        postButton.frame.origin.x = view.frame.width/2 + bottomButtonOffset
        
    }
    
    //when the keyboard is shown, position the bottom buttons so that they are just above the keyboard. The resize the text view accordingly. 
    func keyboardWillShow(_ notification: Notification) {
        let keyboardSize = ((notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
       
        for button in [submitButton,postButton]{
            button.frame.origin.y = view.frame.height - keyboardSize!.height - button.frame.height - bottomButtonOffset
        }
        
        photoButton.frame.origin.y = submitButton.frame.origin.y - photoButton.frame.height - bottomButtonOffset
        cameraButton.center.y = photoButton.center.y
        numberOfPhotosButton.center.y = photoButton.center.y
        
         textView.frame.size.height = photoButton.frame.origin.y - textView.frame.origin.y
        
        
        
    }

}
