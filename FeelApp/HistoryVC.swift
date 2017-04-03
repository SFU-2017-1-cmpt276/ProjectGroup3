
//FeelApp
//This is the History view controller. For the user to view their emotional history.
///Programmers: Deepak and Carson
//Version 1: Created UI with no actions. Cells do not expand when clicked.
//Version 2: Connected to Firebase. Table cell now populates with values from the database.
//Version 3: Improved UI. Table cell font and color change with emotion. Cells expand to show text.
//Version 4: Reversed the order of the posts: newest appears on top now. 

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
    var chartButton = UIButton()
    var calendarButton = UIButton()
    
    let offset:CGFloat = 0
    
    var historyView:HistoryView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
     // set up table view and top bar and general view. get data from firebase. 
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        setUpTopView()
        setUpView()
        getEmotions()
        
        // Do any additional setup after loading the view.
    }
    
    func calendarBackButtonClicked() {
        dismiss(animated: false, completion: nil)
    }
    
    
    
    //Set up the top bar. The view, back button, and title label.
    func setUpTopView(){
        let size = CGSize(width: 50, height: 50)
        let inset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        
        topView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: 70))
        view.addSubview(topView)
        topView.backgroundColor = UIColor.white
        
        
        backButton.frame.size = size
        backButton.setImage(#imageLiteral(resourceName: "leftArrowIcon.png"), for: .normal)
        backButton.contentEdgeInsets = inset
        
        topView.backgroundColor = nowColor
        
        topView.addSubview(backButton)
        backButton.changeToColor(UIColor.white)
        backButton.frame.origin.y = topView.frame.height - backButton.frame.height
        backButton.frame.origin.x = 0
        backButton.addTarget(self, action: #selector(HistoryVC.backAction), for: .touchUpInside)
        
        titleLabel.font = Font.PageHeaderSmall()
        titleLabel.text = "History"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
        topView.addSubview(titleLabel)
        
        chartButton.frame.size = size
        chartButton.setImage(#imageLiteral(resourceName: "pieChartIcon.png"), for: .normal)
        chartButton.contentEdgeInsets = inset
        topView.addSubview(chartButton)
        chartButton.changeToColor(UIColor.white)
        chartButton.frame.origin.y = topView.frame.height - chartButton.frame.height
        chartButton.frame.origin.x = view.frame.width - chartButton.frame.width
        chartButton.addTarget(self, action: #selector(HistoryVC.toChart), for: .touchUpInside)
        chartButton.isHidden = true
        
        calendarButton.frame.size = size
        calendarButton.setImage(#imageLiteral(resourceName: "calendarIcon"), for: .normal)
        calendarButton.contentEdgeInsets = inset
        topView.addSubview(calendarButton)
        calendarButton.changeToColor(UIColor.white)
        calendarButton.frame.origin.y = topView.frame.height - chartButton.frame.height
        calendarButton.frame.origin.x = view.frame.width - calendarButton.frame.width
        calendarButton.addTarget(self, action: #selector(HistoryVC.toCalendar), for: .touchUpInside)
    }
    
    func toCalendar(){
        let vc = CalendarVC()
        vc.allEmotions = historyView.emotions
        //vc.modalTransitionStyle = .crossDissolve
        
        present(vc, animated: false, completion: nil)
    }
    //top right button action for opening the chartVC.
    func toChart(){
        let vc = ChartVC()
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    //action called by back button. dismiss view controller
    func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    //setup the general view. In this case, its the HistoryView. set its size and position.
    func setUpView(){
        historyView = HistoryView(size:CGSize(width:view.frame.width - 2*offset,height:view.frame.height - topView.frame.height - offset))
        historyView.frame.origin.y = topView.frame.height + offset
        historyView.center.x = view.frame.width/2
        view.addSubview(historyView)
    }
    
    //get emotion data from firebase. add it to the emotions array of the history view. then reload the history view so that it displays all this data. 
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
            self.historyView.emotions.sort(by: {$1.time < $0.time})
            self.historyView.reloadData()
            
        })
    }

}
