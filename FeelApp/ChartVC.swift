//
//  ChartVC.swift
//  FeelApp
//
//  Created by Deepak Venkatesh on 2017-03-15.
//  Copyright © 2017 CMPT276. All rights reserved.
//

import UIKit
import Charts
import FirebaseDatabase

class ChartVC: UIViewController {

    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    
    
    var pieChartView = PieChartView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{return UIStatusBarStyle.lightContent}
    
    var counts:[String:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        setUpTopView()
        getEmotions()
        // Do any additional setup after loading the view.
    }
    
    func setUpView(){
        view.backgroundColor = UIColor.white
    }
    
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
        backButton.addTarget(self, action: #selector(ChartVC.backAction), for: .touchUpInside)

        titleLabel.font = Font.PageHeaderSmall()
        titleLabel.text = "Chart"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
        topView.addSubview(titleLabel)
        
    }
    
    func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    class someFormatter:NSObject,IValueFormatter{
        func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            let formatter = NumberFormatter()
            
            formatter.numberStyle = .none
            formatter.maximumFractionDigits = 1
            formatter.multiplier = 1.0
            return formatter.string(from: value as! NSNumber)!
        }
    }
    
    
    func setUpChart(){
        
        view.addSubview(pieChartView)
        pieChartView.frame = CGRect(x: 0, y: topView.frame.height, width: view.frame.width, height: view.frame.height - topView.frame.height)
        
        var dataEntries: [PieChartDataEntry] = []
        
        for (type,count) in counts {
            
            let dataEntry = PieChartDataEntry(value: Double(count), label: type)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Units Sold")

        pieChartDataSet.valueFormatter = someFormatter()
        

        
        let pieChartData = PieChartData(dataSet: pieChartDataSet as IChartDataSet)//PieChartData(dataSets: (pieChartDataSet as IChartDataSet) as! [IChartDataSet])
 


        pieChartView.data = pieChartData
      
        
        
        var colors: [UIColor] = []
        
         for (type,count) in counts {

            colors.append(Emotion.fromString(type).color)
        }
        
        pieChartDataSet.colors = colors
        let string = NSMutableAttributedString(string: "Emotions", attributes: [NSFontAttributeName:Font.PageHeaderSmall(),NSForegroundColorAttributeName:nowColor])
        pieChartView.centerAttributedText = string
        pieChartView.chartDescription = nil
        pieChartView.legend.enabled = false
        pieChartDataSet.entryLabelFont = Font.PageBodyBold()
        pieChartDataSet.valueFont = Font.PageBodyBold()

        
    }
    
    func getEmotions(){
        
        FIRDatabase.database().reference().child("Emotions").child(userUID).observeSingleEvent(of: .value, with: {allSnap in
            let dict = allSnap.value as? [String:AnyObject] ?? [:]
            
            for (id,singleEmotionDict) in dict{
                
                let type = singleEmotionDict["Type"] as? String ?? ""
                
                if self.counts[type] == nil{
                    self.counts[type] = 1
                }
                else{
                    self.counts[type]!+=1
                }

            }
            print(self.counts)
            self.setUpChart()
            
        })
    }

}
