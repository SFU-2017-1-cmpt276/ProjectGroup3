//FeelApp
//This is the Calendar view controller. Allows users to view their emotional history based on the day and month selected on the calendar
///Programmers: Deepak and Carson
//Version 1: Created Calendar VC and setupHistoryView()
//Version 2: Connected to database.
//Version 3: Improved UI. Swapped views for CalendarVC and setupHistoryView()
//Version 4: Fixed bug where the day in the month was shifted
//Version 5: Fixed bug where selecting a day will select the same in in the current and previous month

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"


import UIKit
import FirebaseDatabase



class CalendarVC: UIViewController,CalendarViewDelegate,HistoryViewDelegate {

    var scrollView = UIScrollView()
    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    
    
    var calendarView:CalendarView!
    
    
    var noEmotionsLabel = UILabel()
    
    var historyView:HistoryView!
    
    var allEmotions:[Emotion] = []
    
    var calendar = Calendar.current
    var formatter = DateFormatter()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpScrollView()
        setUpTopView()
        setUpCalendarView()
        setUpHistoryView()
    }
    
    func setUpView(){
        view.backgroundColor = UIColor.white
    }

    //Set up the top bar. The view, back button, and title label.
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
        backButton.addTarget(self, action: #selector(CalendarVC.backAction), for: .touchUpInside)
        
        titleLabel.font = Font.PageHeaderSmall()
        titleLabel.text = "Calendar"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
        topView.addSubview(titleLabel)
        
    }
    
    // Allows the calendar view and history view to scroll
    func setUpScrollView(){
        view.addSubview(scrollView)
        scrollView.frame.size.width = view.frame.width
        scrollView.frame.size.height = view.frame.height - topView.frame.height
        scrollView.frame.origin.y = topView.frame.height
        scrollView.showsVerticalScrollIndicator = false
    }
    
    // Opens photo if it was included in the emotion post
    func photoButtonClicked(emotion: Emotion) {
        let vc = PhotoViewerVC2()
        vc.emotion = emotion
        present(vc, animated: true, completion: nil)
    }
    
    // Creates the area where the calendar is displayed
    func setUpCalendarView(){
        calendarView = CalendarView(width: view.frame.width,allEmotions:allEmotions)
        calendarView.delegate = self
        scrollView.addSubview(calendarView)
        calendarView.frame.origin.y = topView.frame.height
    }
    
    // Creates the area where the emotional history for that day is displayed
    func setUpHistoryView(){
        let originY:CGFloat = calendarView.frame.maxY
        historyView = HistoryView(size:CGSize(width:view.frame.width,height:view.frame.height - originY),showTimeAlways:true)
        historyView.someDelegate = self
        historyView.frame.origin.y =  originY
        historyView.center.x = view.frame.width/2
        scrollView.addSubview(historyView)
        historyView.backgroundColor = UIColor.white
        historyView.isScrollEnabled = false
        
        noEmotionsLabel.text = "No emotions"
        noEmotionsLabel.font = Font.NoPostsFont()
        noEmotionsLabel.textColor = globalGreyColor
        scrollView.addSubview(noEmotionsLabel)
        noEmotionsLabel.sizeToFit()
        noEmotionsLabel.center.x = view.frame.width/2
        
        noEmotionsLabel.center.y = historyView.center.y - 30
        noEmotionsLabel.isHidden = true
        
        self.filterHistory(date:Date())
    }
    
    func monthButtonClicked() {
        historyView.frame.origin.y =  calendarView.frame.maxY
        scrollView.contentSize.height = historyView.frame.maxY
    }
    func backAction(){
        dismiss(animated: false, completion: nil)
    }
    
    func dateClicked(date:Date){
        filterHistory(date: date)
    }
    
    // Find the data from user history to display when specific date is chosen
    func filterHistory(date:Date){
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        historyView.emotions = []
        for emotion in allEmotions{
            let someDate = Date(timeIntervalSince1970: emotion.time/1000)
            let someDay = calendar.component(.day, from: someDate)
            let someMonth = calendar.component(.month, from: someDate)
            let someYear = calendar.component(.year, from: someDate)
            if someDay == day && someMonth == month && someYear == year{
                historyView.emotions.append(emotion)
            }
            
        }
        if historyView.emotions.count == 0{
            noEmotionsLabel.isHidden = false
        }
        else{noEmotionsLabel.isHidden = true}
        
        historyView.reloadData()
        historyView.frame.size.height = historyView.collectionViewLayout.collectionViewContentSize.height
        scrollView.contentSize.height = historyView.frame.maxY
    }
}

