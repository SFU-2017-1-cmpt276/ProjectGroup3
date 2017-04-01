//
//  CalendarVC.swift
//  FeelApp
//
//  Created by Deepak Venkatesh on 2017-03-29.
//  Copyright © 2017 CMPT276. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CalendarVC: UIViewController {

    //some data stuff
    var startingDay = 0
    var numberOfDaysCurrentMonth = 0
    var numberOfDaysPreviousMonth = 0
    var isCurrentMonth = false
    var selectedDay = -1
    var displayDate = Date()
    var calendar = Calendar.current
    var formatter = DateFormatter()
    
    var someIndexes = [15,20,22,24]
    
    //topview
    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    
    
    var collectionView:UICollectionView!
    var width:CGFloat!
    var dayLabels:[UILabel] = []
    
    var monthLabel = UILabel()
    var nextButton = UIButton()
    var previousButton = UIButton()
    
    var historyView:HistoryView!
    
    var allEmotions:[Emotion] = []
    
    var dict:[Int:Int] = [:]
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
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
                self.allEmotions.append(emotion)
                
            }
            self.allEmotions.sort(by: {$1.time < $0.time})
            self.filterHistory(date:Date())
            self.getEmotionCounts()
            self.collectionView.reloadData()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpTopView()
        
        setUpDateStuff()
        setUpDayLabels()
        setUpCollectionView()
        changeMonthAction(sender: nextButton)
        changeMonthAction(sender: previousButton)
        
        
        let offset:CGFloat = 0
        //collectionView.frame.size.height = 250
        historyView = HistoryView(size:CGSize(width:view.frame.width - 2*offset,height:view.frame.height - topView.frame.height - offset))
        historyView.frame.origin.y =  collectionView.frame.maxY - 300//dayLabels[0].frame.maxY + 300//label.frame.maxY //collectionView.frame.height - 165//topView.frame.height + offset
        historyView.center.x = view.frame.width/2
        view.addSubview(historyView)
        //historyView.frame.size.height = monthLabel.frame.origin.y - historyView.frame.origin.y - 10
        //topView.estimatedRowHeight = 100
        historyView.frame.size.height = 300
        historyView.backgroundColor = UIColor.white
        
        
        //collectionView.frame.origin.y = 600
        //monthLabel.frame.origin.y = topView.frame.origin.y + 80
        //nextButton.frame.origin.y = topView.frame.origin.y + 80
        //previousButton.frame.origin.y = topView.frame.origin.y + 80
        
        //historyView.frame.origin.y = 300
        //collectionView.frame.size.height = collectionView.sizeToFit()
        
        //collectionview.frame.
        
        
        
        getEmotions()
        
    }
    
    func getEmotionCounts(){
        
        let month = calendar.component(.month, from: displayDate)
        let year = calendar.component(.year, from: displayDate)
        
        dict = [:]
        for emotion in allEmotions{
            let someDate = Date(timeIntervalSince1970: emotion.time/1000)
            let someDay = calendar.component(.day, from: someDate)
            let someMonth = calendar.component(.month, from: someDate)
            let someYear = calendar.component(.year, from: someDate)
            
            if someMonth == month && someYear == year{
                
                if dict[someDay] == nil{
                    dict[someDay] = 1
                }
                else{
                    dict[someDay]! += 1
                }
            }
            
        }
        

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
        
        historyView.reloadData()
        
        
    }

    
    func setUpView(){
        view.backgroundColor = UIColor.white
        width = (view.frame.width - 30)/7
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
    
    func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    func setUpDateStuff(){

        selectedDay = calendar.component(.day, from: Date())
        
        formatter.dateFormat = "MMMM yyyy"
        monthLabel = UILabel()
        monthLabel.text = "asdfasdf"
        monthLabel.sizeToFit()
        view.addSubview(monthLabel)
        monthLabel.center.x = view.frame.width/2
        //monthLabel.frame.origin.y = topView.frame.height + 20
        monthLabel.frame.origin.y =  titleLabel.frame.maxY + 50
        
        nextButton.frame.size = CGSize(width: 35, height: 35)
        nextButton.setImage(#imageLiteral(resourceName: "rightArrowIcon"), for: .normal)
        view.addSubview(nextButton)
        nextButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        nextButton.layer.cornerRadius = 17.5
        //nextButton.layer.borderWidth = 2
        nextButton.layer.borderColor = nowColor.cgColor
        nextButton.center.y = monthLabel.center.y
        //nextButton.changeToColor(nowColor)
        nextButton.addTarget(self, action: #selector(CalendarVC.changeMonthAction(sender:)), for: .touchUpInside)
        
        previousButton.frame.size = CGSize(width: 35, height: 35)
        previousButton.setImage(#imageLiteral(resourceName: "leftArrowIcon"), for: .normal)
        previousButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        previousButton.layer.cornerRadius = 17.5
       // previousButton.layer.borderWidth = 2
        previousButton.layer.borderColor = nowColor.cgColor
        view.addSubview(previousButton)
        //previousButton.changeToColor(nowColor)
        previousButton.center.y = monthLabel.center.y
        previousButton.addTarget(self, action: #selector(CalendarVC.changeMonthAction(sender:)), for: .touchUpInside)
        
        nextButton.frame.origin.x = view.frame.width - previousButton.frame.width - 15
        //nextButton.frame.origin.y = topView.frame.origin.y + 80
        previousButton.frame.origin.x = 15
        //previousButton.frame.origin.y = titleLabel.frame.origin.y + 80
        
    }


    func changeMonthAction(sender:UIButton){

        
        if sender == nextButton{
        
        displayDate = Calendar.current.date(byAdding: .month, value: 1, to: displayDate)!
        }
        else{
            displayDate = Calendar.current.date(byAdding: .month, value: -1, to: displayDate)!
        }
        
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        let displayMonth = calendar.component(.month, from: displayDate)
        let displayYear = calendar.component(.year, from: displayDate)
        
        if currentYear == displayYear && currentMonth == displayMonth{
            isCurrentMonth = true
        }
        else{isCurrentMonth = false}
        
        numberOfDaysCurrentMonth = calendar.range(of: .day, in: .month, for: displayDate)!.count
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: displayDate)!
        numberOfDaysPreviousMonth = calendar.range(of: .day, in: .month, for: previousMonth)!.count
        
        let weekday = calendar.component(.weekday, from: displayDate)
        startingDay = weekday-1
        
        monthLabel.text = formatter.string(from: displayDate)
        monthLabel.text = monthLabel.text?.uppercased()
        monthLabel.sizeToFit()
        monthLabel.center.x = view.frame.width/2
        
        getEmotionCounts()
        collectionView.reloadData()
        collectionView.frame.origin.y = 150
        
        for label in dayLabels{
            label.frame.origin.y = collectionView.frame.origin.y - label.frame.height - 15
        }
        //monthLabel.frame.origin.y = dayLabels[0].frame.origin.y - monthLabel.frame.height - 20
        monthLabel.frame.origin.y = titleLabel.frame.origin.y + 50
        previousButton.center.y = monthLabel.center.y
        nextButton.center.y = monthLabel.center.y
    }
    
    func setUpCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let originY = dayLabels[0].frame.maxY + 15
        let frame = CGRect(x: 15, y: originY, width: view.frame.width - 30, height: view.frame.height - originY)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.white
        //collectionView.sizeToFit()
        //collectionView.frame.origin.y = 200;
        //collectionView.
    }
    
    func setUpDayLabels(){
        let array = ["SUN","MON","TUE","WED","THUR","FRI","SAT"]
        
        
        for i in 0 ..< array.count{
            let label = UILabel()
            label.text = array[i]
            label.sizeToFit()
            label.font = Font.PageBodyBold()
            view.addSubview(label)
            label.textAlignment = .center
            label.frame.size.width = width
            dayLabels.append(label)
            //label.frame.origin.y = monthLabel.frame.maxY + 30
            label.frame.origin.y =  100
            label.frame.origin.x = 15 + CGFloat(i) * width
        }
    }
}

extension CalendarVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysCurrentMonth + startingDay
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < startingDay{return}
        var components = DateComponents()
        components.day = indexPath.item + 1 - startingDay
        components.month = calendar.component(.month, from: displayDate)
        components.year = calendar.component(.year, from: displayDate)
        let date = calendar.date(from: components)!
        filterHistory(date: date)
        selectedDay = indexPath.item + 1 - startingDay
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = width/2
        cell.clipsToBounds = false
        //cell.frame.size.height = 200
        
        var label:UILabel!
        var numberLabel:UILabel!
        
        var createNewLabel = true
        for subview in cell.subviews{
            if subview is UILabel && subview.tag == 1{
                createNewLabel = false
                label = subview as! UILabel
            }
            if subview is UILabel && subview.tag == 2{
                createNewLabel = false
                numberLabel = subview as! UILabel
            }

        }
        
        
        if createNewLabel{
            label = UILabel()
            label.tag = 1
            label.frame.size = CGSize(width: 35, height: 35)
            label.clipsToBounds = true
            label.layer.cornerRadius = 17.5
            label.textAlignment = .center
            cell.addSubview(label)
            
            numberLabel = UILabel()
            numberLabel.frame.size = CGSize(width: 15, height: 15)
            let font = UIFont(name: Font.PageSmallBold().fontName, size: Font.PageSmallBold().pointSize - 4)
            numberLabel.font = font
            numberLabel.textAlignment = .center
            numberLabel.tag = 2
            numberLabel.backgroundColor = nowColor
            numberLabel.textColor = UIColor.white
            numberLabel.clipsToBounds = true
            numberLabel.layer.cornerRadius = numberLabel.frame.width/2
            cell.addSubview(numberLabel)
            
        }
        
        if indexPath.item < startingDay{
            label.text = String(numberOfDaysPreviousMonth - startingDay + indexPath.item + 1)

        }
        else{
            label.text = String(indexPath.item + 1 - startingDay)
        }
        
        
        if isCurrentMonth && Int(label.text!) == selectedDay{
            label.backgroundColor = UIColor.red
            label.font = Font.PageBodyBold()
            label.center = CGPoint(x: width/2, y: width/2)
            label.textColor = UIColor.white
        }
        else{
            label.backgroundColor = UIColor.white
            label.font = Font.PageBody()
            label.center = CGPoint(x: width/2, y: width/2)
            label.textColor = UIColor.black
        }
        if indexPath.item < startingDay{label.textColor = globalGreyColor}
        
        label.layer.borderColor = nowColor.cgColor
        if  !(indexPath.item < startingDay) && dict[indexPath.item + 1 - startingDay] != nil{
            label.layer.borderWidth = 2
            numberLabel.frame.origin.x = label.frame.maxX - 11
            numberLabel.frame.origin.y = label.frame.origin.y - numberLabel.frame.height + 11
            numberLabel.isHidden = false
            numberLabel.text = String(dict[indexPath.item + 1 - startingDay]!)
        }
        else{
            label.layer.borderWidth = 0
            numberLabel.isHidden = true
        }
        
       return cell
    }
}
