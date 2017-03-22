//FeelApp
//This is the Chart view controller. For the user to view their emotions as fractions of a whole.
//Uses ios charts module. open source module for creating graphs.
///Programmers: Deepak and Carson
//Version 1: Basic VC. Chart is unformatted with test data.
//Version 2: Formatted chart and connected to database
//Version 3: Improved UI. Added background colors and title bar.

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"


import UIKit
import Charts
import FirebaseDatabase

class ChartVC: UIViewController {

    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    
    
    var pieChartView = PieChartView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{return UIStatusBarStyle.lightContent}
    
    //the name of each emotion and the number of times you have posted it. use for the pie chart
    var emotionCounts:[String:Int] = [:]
    
    
    
    // set up general view and top bar. Get data from firebase.
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        setUpTopView()
        getEmotions()
        // Do any additional setup after loading the view.
    }
    
    
    //Set up the general view
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
        backButton.addTarget(self, action: #selector(ChartVC.backAction), for: .touchUpInside)

        titleLabel.font = Font.PageHeaderSmall()
        titleLabel.text = "Chart"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
        topView.addSubview(titleLabel)
        
    }
    
    //function called by the back button. Dismiss the view controller
    func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    //set up the chart. Take the emotions from firsebase and present it in a pie chart so that the fraction of each emotion is presented. This uses the ios charts module.
    func setUpChart(){
        
        view.addSubview(pieChartView)
        
        //set up the frame of the chart
        pieChartView.frame = CGRect(x: 0, y: topView.frame.height, width: view.frame.width, height: view.frame.height - topView.frame.height)
        
        
        //create a data entries array. use the
        var dataEntries: [PieChartDataEntry] = []
        
        //for each item in emotion counts (which has the data from the database), make it a data entry for the pie chart
        for (type,count) in emotionCounts {
            
            let dataEntry = PieChartDataEntry(value: Double(count), label: type)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Units Sold")

        //format the text that appears on each pie chart fraction. use the someFormatter() class defined below
        pieChartDataSet.valueFormatter = someFormatter()
        

        let pieChartData = PieChartData(dataSet: pieChartDataSet as IChartDataSet)//PieChartData(dataSets: (pieChartDataSet as IChartDataSet) as! [IChartDataSet])
 


        pieChartView.data = pieChartData
      
        
        
        //create the array of colors that will be used by the pie chart.
        var colors: [UIColor] = []
        
         for (type,count) in emotionCounts {

            colors.append(Emotion.fromString(type).color)
        }
        
        pieChartDataSet.colors = colors
        
        //set the title of the chart
        let string = NSMutableAttributedString(string: "Emotions", attributes: [NSFontAttributeName:Font.PageHeaderSmall(),NSForegroundColorAttributeName:nowColor])
        pieChartView.centerAttributedText = string
        pieChartView.chartDescription = nil
        pieChartView.legend.enabled = false
        pieChartDataSet.entryLabelFont = Font.PageBodyBold()
        pieChartDataSet.valueFont = Font.PageBodyBold()

        
    }
    
    
    //Get the data from firebase. Add it to the emotionCounts array. then call setUpChart()
    func getEmotions(){
        
        FIRDatabase.database().reference().child("Emotions").child(userUID).observeSingleEvent(of: .value, with: {allSnap in
            let dict = allSnap.value as? [String:AnyObject] ?? [:]
            
            for (id,singleEmotionDict) in dict{
                
                let type = singleEmotionDict["Type"] as? String ?? ""
                
                if self.emotionCounts[type] == nil{
                    self.emotionCounts[type] = 1
                }
                else{
                    self.emotionCounts[type]!+=1
                }

            }
            self.setUpChart()
            
        })
    }
    
    
    //value formatter class. Used to format the text of each chart fraction. Implements the IValueFormatter abstract class from the ios charts module. 
    class someFormatter:NSObject,IValueFormatter{
        func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            let formatter = NumberFormatter()
            
            formatter.numberStyle = .none
            formatter.maximumFractionDigits = 1
            formatter.multiplier = 1.0
            return formatter.string(from: value as! NSNumber)!
        }
    }
}
