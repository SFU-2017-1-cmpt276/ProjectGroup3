//
//  Calendarswift
//  FeelApp
//
//  Created by Deepak Venkatesh on 2017-04-02.
//  Copyright © 2017 CMPT276. All rights reserved.
//

import UIKit

protocol CalendarViewDelegate{
    func dateClicked(date:Date)->Void
    func monthButtonClicked()->Void
}
class CalendarView: UIView {

    var delegate:CalendarViewDelegate?
    var startingDay = 0
    var numberOfDaysDisplayMonth = 0
    var numberOfDaysPreviousMonth = 0
    var displayMonth = 4
    var displayYear = 2017
    var calendar = Calendar.current
    var formatter = DateFormatter()
    var selectedDate = Date()
    
    
    var singleWidth:CGFloat = 0
    var singleHeight:CGFloat = 0
    
    var dict:[Int:Int] = [:]
    var allEmotions:[Emotion] = []
    
    var monthLabel = UILabel()
    var nextButton = UIButton()
    var previousButton = UIButton()
    
    var collectionView:UICollectionView!
    
    var dayLabels:[UILabel] = []

    init(width:CGFloat,allEmotions:[Emotion]){
        super.init(frame: CGRect())
        self.allEmotions = allEmotions
        frame.size.width = width
        singleWidth = (frame.width - 30)/7
        singleHeight = 50
        
        setUpDateStuff()
        setUpDayLabels()
        setUpCollectionView()
        collectionView.reloadData()
        collectionView.frame.size.height = collectionView.collectionViewLayout.collectionViewContentSize.height
        frame.size.height = collectionView.frame.maxY
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: singleWidth, height: singleHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let originY = dayLabels[0].frame.maxY + 15
        let someFrame = CGRect(x: 0, y: originY, width: frame.width, height: singleHeight*6 + 10)
        collectionView = UICollectionView(frame: someFrame, collectionViewLayout: layout)
        addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.white
    }
    
    func setNumberOfDays(){
        
        var components = DateComponents()
        components.year = displayYear
        components.month = displayMonth
        var date = calendar.date(from: components)!
        numberOfDaysDisplayMonth = calendar.range(of: .day, in: .month, for: date)!.count
        
        if displayMonth == 0{
            components.year = displayYear-1
            components.month = 12
        }
        else{
            components.year = displayYear
            components.month = displayMonth-1
        }
         date = calendar.date(from: components)!
         numberOfDaysPreviousMonth = calendar.range(of: .day, in: .month, for: date)!.count
    }
    
    func getEmotionCounts(){
        
        
        dict = [:]
        for emotion in allEmotions{
            let someDate = Date(timeIntervalSince1970: emotion.time/1000)
            let someDay = calendar.component(.day, from: someDate)
            let someMonth = calendar.component(.month, from: someDate)
            let someYear = calendar.component(.year, from: someDate)
            
            if someMonth == displayMonth && someYear == displayYear{
                
                if dict[someDay] == nil{
                    dict[someDay] = 1
                }
                else{
                    dict[someDay]! += 1
                }
            }
            
        }

    }
    
    func setUpDateStuff(){
        
        formatter.dateFormat = "MMMM yyyy"
        monthLabel = UILabel()
        monthLabel.text = "asdfasdf"
        monthLabel.sizeToFit()
        addSubview(monthLabel)
        monthLabel.center.x = frame.width/2
        monthLabel.frame.origin.y = 25
        
        nextButton.frame.size = CGSize(width: 35, height: 35)
        nextButton.setImage(#imageLiteral(resourceName: "rightArrow2"), for: .normal)
        addSubview(nextButton)
        nextButton.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
        nextButton.layer.cornerRadius = 17.5
        nextButton.layer.borderWidth = 1.5
        nextButton.layer.borderColor = UIColor.black.cgColor
        nextButton.center.y = monthLabel.center.y
        //nextButton.changeToColor(nowColor)
        nextButton.addTarget(self, action: #selector(CalendarView.changeMonthAction(sender:)), for: .touchUpInside)
        
        previousButton.frame.size = CGSize(width: 35, height: 35)
        previousButton.setImage(#imageLiteral(resourceName: "leftArrow2"), for: .normal)
        previousButton.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
        previousButton.layer.cornerRadius = 17.5
        previousButton.layer.borderWidth = 1.5
        previousButton.layer.borderColor = UIColor.black.cgColor
        addSubview(previousButton)
        //previousButton.changeToColor(nowColor)
        previousButton.center.y = monthLabel.center.y
        previousButton.addTarget(self, action: #selector(CalendarView.changeMonthAction(sender:)), for: .touchUpInside)
        
        nextButton.frame.origin.x = frame.width - previousButton.frame.width - 15
        //nextButton.frame.origin.y = topframe.origin.y + 80
        previousButton.frame.origin.x = 15
        //previousButton.frame.origin.y = titleLabel.frame.origin.y + 80
        
        let date = Date()
        displayMonth = calendar.component(.month, from: date)
        displayYear = calendar.component(.year, from: date)
        
        var components: DateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        components.setValue(1, for: .day)
        let firstOfMonth = calendar.date(from: components)!
        
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        
        startingDay = weekday-1
        print(startingDay)

        
        monthLabel.text = formatter.string(from: date)
        monthLabel.text = monthLabel.text?.uppercased()
        monthLabel.font = Font.PageBodyBold()
        monthLabel.sizeToFit()
        monthLabel.center.x = frame.width/2
        setNumberOfDays()
        getEmotionCounts()
        
    }
    
    func changeMonthAction(sender:UIButton){
        
        if sender == nextButton{
            
            self.displayMonth += 1
            if displayMonth == 13{
                displayMonth = 1
                displayYear += 1
            }
        }
        else{
            displayMonth -= 1
            if displayMonth == 0{
                displayMonth = 12
                displayYear -= 1
            }
        }
        
        setNumberOfDays()
        var components = DateComponents()
        components.month = displayMonth
        components.year = displayYear
        let date = calendar.date(from: components)!
        
        components.setValue(1, for: .day)
        let firstOfMonth = calendar.date(from: components)!
        
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        
        startingDay = weekday-1
        print(startingDay)
        
        
        monthLabel.text = formatter.string(from: date)
        monthLabel.text = monthLabel.text?.uppercased()
        monthLabel.sizeToFit()
        monthLabel.center.x = frame.width/2
        
        getEmotionCounts()
        collectionView.reloadData()
        collectionView.frame.size.height = collectionView.collectionViewLayout.collectionViewContentSize.height
        frame.size.height = collectionView.frame.maxY
        delegate?.monthButtonClicked()
    }
    
    func setUpDayLabels(){
        let array = ["S","M","T","W","T","F","S"]
        
        
        for i in 0 ..< array.count{
            let label = UILabel()
            label.text = array[i]
            label.sizeToFit()
            label.textColor = UIColor.black
            label.font = Font.PageSmallBold()
            addSubview(label)
            label.textAlignment = .center
            label.frame.size.width = singleWidth
            dayLabels.append(label)
            label.frame.origin.y = monthLabel.frame.maxY + 25
            label.frame.origin.x = 15 + CGFloat(i) * singleWidth
        }
    }


}

extension CalendarView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysDisplayMonth + startingDay
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < startingDay{return}
        var components = DateComponents()
        components.day = indexPath.item + 1 - startingDay
        components.month = displayMonth
        components.year = displayYear
        let date = calendar.date(from: components)!
        delegate?.dateClicked(date: date)
        collectionView.reloadData()
        selectedDate = date
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
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
            numberLabel.backgroundColor = UIColor.blue
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
        
        let components = calendar.dateComponents([.day,.month,.year], from: selectedDate)
        
        
        if indexPath.item + 1 - startingDay == components.day! && displayMonth == components.month! && displayYear == components.year!{
            
            label.backgroundColor = UIColor.blue.withAlphaComponent(0.65)
            label.font = Font.PageBodyBold()
            label.center = CGPoint(x: singleWidth/2, y: singleHeight/2)
            label.textColor = UIColor.white
            label.layer.borderWidth = 2
        }
        else{
            label.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
            label.font = Font.PageBody()
            label.center = CGPoint(x: singleWidth/2, y: singleHeight/2)
            label.textColor = UIColor.blue
            label.layer.borderWidth = 2
        }
        if indexPath.item < startingDay{
            label.textColor = globalGreyColor
            label.backgroundColor = UIColor.white
            label.layer.borderWidth = 0
        }
        
        label.layer.borderColor = UIColor.blue.cgColor
        if  !(indexPath.item < startingDay) && dict[indexPath.item + 1 - startingDay] != nil{
            label.layer.borderWidth = 2
            numberLabel.frame.origin.x = label.frame.maxX - 11
            numberLabel.frame.origin.y = label.frame.origin.y - numberLabel.frame.height + 11
            numberLabel.isHidden = false
            numberLabel.text = String(dict[indexPath.item + 1 - startingDay]!)
        }
        else{
            numberLabel.isHidden = true
        }
        
        return cell
    }
}

