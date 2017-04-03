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

    var scrollView = UIScrollView()
    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    
    
    var pieChartView = PieChartView()
    
    var buttons:[UIButton]{
        return [weekButton,monthButton,totalButton]
    }
    var weekButton = UIButton()
    var monthButton = UIButton()
    var totalButton = UIButton()
    
    var tableView = UITableView()
    
    var nothingThereLabel = UILabel()
    
    var week = true
    var month = false
    var all = false

    override var preferredStatusBarStyle: UIStatusBarStyle{return UIStatusBarStyle.lightContent}
    
    var allEmotions:[Emotion] = []
    //the name of each emotion and the number of times you have posted it. use for the pie chart
    var emotionCounts:[Emotion:Int] = [:]
    var totalCount = 0
    
    
    
    // set up general view and top bar. Get data from firebase.
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        setUpTopView()
        view.addSubview(scrollView)
        scrollView.frame.size.width = view.frame.width
        scrollView.frame.size.height = view.frame.height - topView.frame.height - 20
        scrollView.frame.origin.y = topView.frame.height
        scrollView.showsVerticalScrollIndicator = false
        setUpButtons()
        scrollView.addSubview(pieChartView)
        
        //set up the frame of the chart
        let originY = buttons[0].frame.maxY + 10
        pieChartView.frame = CGRect(x: 0, y: originY, width: view.frame.width*(3/4), height: view.frame.width*(3/4))
        pieChartView.center.x = view.frame.width/2
        
        // Do any additional setup after loading the view.
    }
    
    
    //Set up the general view
    func setUpView(){
        view.backgroundColor = UIColor.white
        nothingThereLabel.text = "No data available"
        nothingThereLabel.font = Font.NoPostsFont()
        nothingThereLabel.textColor = globalGreyColor
        nothingThereLabel.sizeToFit()
        view.addSubview(nothingThereLabel)
        nothingThereLabel.center.x = view.frame.width/2
        nothingThereLabel.center.y = view.frame.height/2
        nothingThereLabel.isHidden = true
    }
    
    
    func setUpButtons(){
        let titles = ["Week","Month","All"]
        for i in 0 ..< buttons.count{
            let someButton = buttons[i]
            someButton.frame.size = CGSize(width: 80, height: 42)
            someButton.setTitle(titles[i], for: .normal)
            someButton.frame.origin.y = 20
            scrollView.addSubview(someButton)
            someButton.clipsToBounds = true
            someButton.layer.cornerRadius = 5
            someButton.addTarget(self, action: #selector(ChartVC.buttonAction(sender:)), for: .touchUpInside)
        }
        
        buttons[1].center.x = view.frame.width/2
        buttons[0].frame.origin.x = buttons[1].frame.origin.x - 10 - buttons[0].frame.width
        buttons[2].frame.origin.x = buttons[1].frame.maxX + 10
        buttonAction(sender: buttons[0])
    }
    
    func buttonAction(sender:UIButton){
        for button in buttons{
            button.backgroundColor = UIColor(white: 0.93, alpha: 1)
            button.titleLabel?.font = Font.PageBody()
            button.setTitleColor(UIColor.black, for: .normal)
        }
        sender.backgroundColor = nowColor
        sender.titleLabel?.font = Font.PageBodyBold()
        sender.setTitleColor(UIColor.white, for: .normal)
        
        switch sender{
        case weekButton:
            
            week = true
            month = false
            all = false
            
        case monthButton:
            week = false
            month = true
            all = false
            
        case totalButton:
            week = false
            month = false
            all = true
            
        default:break
        }
        
        processEmotions(week: week, month: month, all: all)
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
        

        //create a data entries array. use the
        var dataEntries: [PieChartDataEntry] = []
        
        //for each item in emotion counts (which has the data from the database), make it a data entry for the pie chart
        for (emotion,count) in emotionCounts {
            
            let dataEntry = PieChartDataEntry(value: Double(count), label: emotion.name)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Units Sold")

        //format the text that appears on each pie chart fraction. use the someFormatter() class defined below
        pieChartDataSet.valueFormatter = someFormatter()
        

        let pieChartData = PieChartData(dataSet: pieChartDataSet as IChartDataSet)//PieChartData(dataSets: (pieChartDataSet as IChartDataSet) as! [IChartDataSet])
        


        pieChartView.data = pieChartData
        pieChartView.transparentCircleRadiusPercent = 0
        pieChartView.holeRadiusPercent = 0.6
        pieChartView.drawEntryLabelsEnabled = false

        //create the array of colors that will be used by the pie chart.
        var colors: [UIColor] = []
        
         for (emotion,count) in emotionCounts {

            colors.append(emotion.color)
        }
        
        pieChartDataSet.colors = colors
        
        //set the title of the chart
        let string = NSMutableAttributedString(string: "Emotions", attributes: [NSFontAttributeName:Font.PageHeaderSmall(),NSForegroundColorAttributeName:nowColor])
        pieChartView.centerAttributedText = nil//string
        pieChartView.chartDescription = nil
        pieChartView.legend.enabled = false
        pieChartDataSet.entryLabelFont = Font.PageBodyBold()
        pieChartDataSet.valueFont = Font.PageBodyBold()
    }
    
    func processEmotions(week:Bool,month:Bool,all:Bool){
        emotionCounts = [:]
        totalCount = 0
        
        let today = Date()
        
        var maxNumber = 0
        if week{maxNumber = 7}
        else if month{maxNumber = 31}
        else if all{maxNumber = IntegerLiteralType.max}
        
        for emotion in allEmotions{
            let date = Date(timeIntervalSince1970: emotion.time/1000)
            
            if today.days(from: date) <= maxNumber{
                    
                if self.emotionCounts[emotion] == nil{
                    self.emotionCounts[emotion] = 1
                    
                }
                else{
                    self.emotionCounts[emotion]!+=1
                }
                self.totalCount += 1
            }
            
        }
        setUpChart()
        tableView.reloadData()
        tableView.frame.size.height = tableView.rowHeight * CGFloat(emotionCounts.count)
        tableView.isScrollEnabled = false
        scrollView.contentSize.height = tableView.frame.maxY
        
        if emotionCounts.count == 0
        {nothingThereLabel.isHidden = false
            pieChartView.isHidden = true
        }
        else{
            nothingThereLabel.isHidden = true
            pieChartView.isHidden = false
        }
    }
    
    //Get the data from firebase. Add it to the emotionCounts array. then call setUpChart()
    func getEmotions(){
        
        self.allEmotions = []
        FIRDatabase.database().reference().child("Emotions").child(userUID).observeSingleEvent(of: .value, with: {allSnap in
            let dict = allSnap.value as? [String:AnyObject] ?? [:]
            
            
            for (id,singleEmotionDict) in dict{
                
                let type = singleEmotionDict["Type"] as? String ?? ""
                var emotion = Emotion()
                if type.lowercased() == "custom"{
                    let colorDict = singleEmotionDict["Color"] as? [String:CGFloat] ?? [:]
                    let red = colorDict["Red"] ?? 0.5
                    let green = colorDict["Green"] ?? 0.5
                    let blue = colorDict["Blue"] ?? 0.5
                    emotion.color = UIColor(red: red, green: green, blue: blue, alpha: 1)
                    emotion.name = singleEmotionDict["Name"] as? String ?? ""
                    emotion.custom = true
                    print(singleEmotionDict)
                    
                }
                else{
                emotion = Emotion.fromString(type)
                }
                emotion.text = singleEmotionDict["Text"] as? String ?? ""
                emotion.id = id
                emotion.time = singleEmotionDict["Time"] as? TimeInterval ?? TimeInterval()
                self.allEmotions.append(emotion)
                
                
            }
            self.setUpTableView()
            self.processEmotions(week: self.week, month: self.month, all: self.all)
            
        })
    }
    
    func setUpTableView(){
        let originY = pieChartView.frame.maxY
        tableView.frame = CGRect(x: 0, y: originY, width: view.frame.size.width, height: view.frame.height - originY)
        tableView.tableFooterView = UIView()
        tableView.register(LegendCell.self, forCellReuseIdentifier: "cell")
        
        scrollView.addSubview(tableView)
        tableView.rowHeight = 60
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.separatorColor = globalLightGrey
        
        tableView.bounces = true
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        
    }
    
    
    //value formatter class. Used to format the text of each chart fraction. Implements the IValueFormatter abstract class from the ios charts module. 
    class someFormatter:NSObject,IValueFormatter{
        func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            let formatter = NumberFormatter()
            
            formatter.numberStyle = .none
            formatter.maximumFractionDigits = 1
            formatter.multiplier = 1.0
            return ""
        }
    }
}

extension ChartVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emotionCounts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LegendCell
        let array = emotionCounts.sorted{ $0.value > $1.value }
        let emotion = array[indexPath.item].key
        let decimal = Float(emotionCounts[emotion]!)/Float(totalCount) * 100
        
        
        cell.setUp(emotion:emotion, total: String(describing: emotionCounts[emotion]!), percent: "\(Int(decimal))%", width: view.frame.width, height: tableView.rowHeight)
        cell.selectionStyle = .none
        return cell
    }
}

class LegendCell:UITableViewCell{
    var dot = UIImageView()
    var nameLabel = UILabel()
    var totalLabel = UILabel()
    var percentLabel = UILabel()
    
    func initStuff(){
        addSubview(dot)
        dot.frame.size = CGSize(width: 15, height: 15)
        dot.layer.cornerRadius = dot.frame.width/2
        dot.layer.borderWidth = 4
        dot.backgroundColor = UIColor.white
        dot.clipsToBounds = true
        
        addSubview(nameLabel)
        nameLabel.font = Font.PageBodyBold()
        
        addSubview(totalLabel)
        totalLabel.font = Font.PageBody()
        totalLabel.textColor = globalGreyColor
        
        addSubview(percentLabel)
        percentLabel.font = Font.PageBodyBold()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initStuff()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(emotion:Emotion,total:String,percent:String,width:CGFloat,height:CGFloat){
        dot.layer.borderColor = emotion.color.cgColor
        dot.isHidden = true
        totalLabel.text = total
        percentLabel.text = percent
        if emotion.custom{
            
        }
        nameLabel.text = emotion.name
        nameLabel.textColor = emotion.color
        let font = UIFont(name: Font.PageBodyBold().fontName, size: Font.PageBodyBold().pointSize + 3)
        nameLabel.font = font
        
        for label in [totalLabel,percentLabel,nameLabel]{
            label.sizeToFit()
            label.center.y = height/2
        }
        dot.center.y = height/2
        
        dot.frame.origin.x = 10
        nameLabel.frame.origin.x = 20
        percentLabel.frame.origin.x = width - percentLabel.frame.width - 20
        totalLabel.frame.origin.x = percentLabel.frame.origin.x - totalLabel.frame.width - 20
    }
}
