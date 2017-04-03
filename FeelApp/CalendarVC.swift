//
//  CalendarVC.swift
//  FeelApp
//
//  Created by Deepak Venkatesh on 2017-03-29.
//  Copyright © 2017 CMPT276. All rights reserved.
//

import UIKit
import FirebaseDatabase



class CalendarVC: UIViewController,CalendarViewDelegate {

    //some data stuff
       //topview
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
    
    func setUpScrollView(){
        view.addSubview(scrollView)
        scrollView.frame.size.width = view.frame.width
        scrollView.frame.size.height = view.frame.height - topView.frame.height
        scrollView.frame.origin.y = topView.frame.height
        scrollView.showsVerticalScrollIndicator = false
    }
    
    func setUpCalendarView(){
        calendarView = CalendarView(width: view.frame.width,allEmotions:allEmotions)
        calendarView.delegate = self
        scrollView.addSubview(calendarView)
        calendarView.frame.origin.y = topView.frame.height
       // Draw.createLineUnderView(calendarView, color: globalLightGrey,width:2)
    }
    
    func setUpHistoryView(){
        let originY:CGFloat = calendarView.frame.maxY
        historyView = HistoryView(size:CGSize(width:view.frame.width,height:view.frame.height - originY),showTimeAlways:true)
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

