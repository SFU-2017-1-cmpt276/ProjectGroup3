
//FeelApp
//This is the History view controller. For the user to view their emotional history.
///Programmers: Deepak and Carson
//Version 1: Created UI with no actions. Cells do not expand when clicked.
//Version 2: Connected to Firebase. Table cell now populates with values from the database.
//Version 3: Improved UI. Table cell font and color change with emotion. Cells expand to show text.

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor followed by "view"
//all other files 



import UIKit
import FirebaseDatabase

class HistoryVC: UIViewController {

    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    var submitButton = UIButton()
    
    let offset:CGFloat = 0
    
    var historyView:HistoryView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        setUpTopView()
        setUpView()
        getEmotions()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpTopView(){
        let size = CGSize(width: 50, height: 50)
        let inset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        topView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: 60))
        view.addSubview(topView)
        topView.backgroundColor = UIColor.white
        
        
        backButton.frame.size = size
        backButton.setImage(#imageLiteral(resourceName: "leftArrowIcon.png"), for: .normal)
        backButton.contentEdgeInsets = inset
        
        topView.addSubview(backButton)
        backButton.changeToColor(UIColor.black)
        backButton.frame.origin.y = topView.frame.height - backButton.frame.height
        backButton.frame.origin.x = 0
        backButton.addTarget(self, action: #selector(HistoryVC.backAction), for: .touchUpInside)
        
        titleLabel.font = Font.PageHeaderSmall()
        titleLabel.text = "History"
        titleLabel.textColor = UIColor.black
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
        topView.addSubview(titleLabel)
        
    }
    
    func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    func setUpView(){
        historyView = HistoryView(size:CGSize(width:view.frame.width - 2*offset,height:view.frame.height - topView.frame.height - offset))
        historyView.frame.origin.y = topView.frame.height + offset
        historyView.center.x = view.frame.width/2
        view.addSubview(historyView)
    }
    
    func getEmotions(){
        
        FIRDatabase.database().reference().child("Emotions").child(userUID).observeSingleEvent(of: .value, with: {allSnap in
            let hello = userUID
            let dict = allSnap.value as? [String:AnyObject] ?? [:]
            
            for (id,singleEmotionDict) in dict{
        
                let type = singleEmotionDict["Type"] as? String ?? ""
                
                let emotion = Emotion.fromString(type)
                emotion.text = singleEmotionDict["Text"] as? String ?? ""
                emotion.id = id
                emotion.time = singleEmotionDict["Time"] as? TimeInterval ?? TimeInterval()
                self.historyView.emotions.append(emotion)
                
            }
            self.historyView.emotions.sort(by: {$0.time < $1.time})
            self.historyView.reloadData()
            
        })
    }

}
