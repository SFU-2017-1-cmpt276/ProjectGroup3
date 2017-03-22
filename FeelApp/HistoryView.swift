//FeelApp
//This is the History collection view. It displays the emotions given to it in a timeline format. The History VC uses this class. 
///Programmers: Deepak and Carson
//Version 1: Created UI.
//Version 2: Improved UI.

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"

import UIKit

class HistoryView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var emotions:[Emotion] = []
    var expandedIndexes:[Int] = []
    
    //the initializer. Input a size. Sets this to be the size of the HistoryView. then calls setup()
    init(size:CGSize){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        super.init(frame: CGRect(origin:CGPoint.zero,size: size), collectionViewLayout: layout)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //set the cell it will use, and other characteristics.
    fileprivate func setUp(){
        
        register(HistoryCell.self, forCellWithReuseIdentifier: "cell")
        delegate = self
        dataSource = self
        backgroundColor = UIColor.white
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        
    }
    
    //collection view data source method. set the number of items to be the count of the emotions array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotions.count
    }
    
    //collection view data source method. Set up the cell to be used.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HistoryCell
        if expandedIndexes.contains(indexPath.item){cell.expanded = true}
        else{cell.expanded = false}
        cell.setUp(emotion: emotions[indexPath.item],width:frame.width)
        return cell
    }
    
    //collection view delegate method. Set the size of each cell.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = HistoryCell(frame: CGRect())
        if expandedIndexes.contains(indexPath.item){cell.expanded = true}
        else{cell.expanded = false}
        cell.setUp(emotion: emotions[indexPath.item],width:frame.width)
        return CGSize(width:frame.width,height:cell.frame.height)
    }
    
    //collection view delegate method. WHen the cell is clicked, expand if currently contracted, and vice versa.
    //The purpose of this is to show/hide the description text that appears for each emotion.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if expandedIndexes.contains(indexPath.item){
            let index = expandedIndexes.index(of: indexPath.item)!
            expandedIndexes.remove(at: index)
            reloadData()
            return
        }
        expandedIndexes.append(indexPath.item)
        reloadData()
    }


}


//the cell to be used by this class/
class HistoryCell:UICollectionViewCell{
    
    var emotion:Emotion!
    let button = UIButton()
    let emotionLabel = UILabel()
    let line = UIView()
    let otherLine = UIView()
    let textLabel = UILabel()
    
    let topBottomOffset:CGFloat = 20
    
    var expanded = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialStuff()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //when cell is first created. general formatting.
    func initialStuff(){
        addSubview(button)
        button.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        addSubview(emotionLabel)
        line.frame.size.height = 0.8
        line.backgroundColor = globalLightGrey
        addSubview(line)
        
        otherLine.frame.size.width = 0.8
        otherLine.backgroundColor = globalLightGrey
        addSubview(otherLine)
        
        textLabel.font = Font.PageBodyBold()
        addSubview(textLabel)
        textLabel.textColor = UIColor.white
        
    }
    
    //outputs the attributed string that says the time posted for the emotion. In the format "8:48 pm."
    func createTimeString()->NSMutableAttributedString{
        
        let formatter = DateFormatter()
        let datePosted = Date(timeIntervalSince1970: emotion.time/1000)
        
        
        formatter.calendar = Calendar.current
        formatter.dateFormat = "h:mm"
        let string = formatter.string(from: datePosted).lowercased()
        formatter.dateFormat = "a"
        let string2 = formatter.string(from: datePosted).lowercased()
        
        
        
        let string3 = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName:Font.PageHeaderSmall(),NSForegroundColorAttributeName:UIColor.white])
        let string4 = NSMutableAttributedString(string: "\n\(string2)", attributes: [NSFontAttributeName:Font.PageBody(),NSForegroundColorAttributeName:UIColor.white])
        string3.append(string4)

        return string3
    }
    
    //outputs the attributed string that says the day posted for the emotion. In the format "20 Mar". Use this if the post is more than a day old
    func createDayString()->NSMutableAttributedString{
        
        let formatter = DateFormatter()
        let datePosted = Date(timeIntervalSince1970: emotion.time/1000)
        
        formatter.calendar = Calendar.current
        formatter.dateFormat = "d"
        let string = formatter.string(from: datePosted).lowercased()
        formatter.dateFormat = "MMM"
        let string2 = formatter.string(from: datePosted)
        
        let string3 = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName:Font.PageHeaderSmall(),NSForegroundColorAttributeName:UIColor.white])
        let string4 = NSMutableAttributedString(string: "\n\(string2)", attributes: [NSFontAttributeName:Font.PageBody(),NSForegroundColorAttributeName:UIColor.white])
        
        string3.append(string4)
            
        return string3
    }
    
    //use the inputted emotion object to set up the cell with specific characteristics. Size and rearrange the elements based on the inputted width of the cell. 
    func setUp(emotion:Emotion,width:CGFloat){
        
        self.emotion = emotion
        backgroundColor = emotion.color
        
        button.titleLabel?.numberOfLines = 0

        let datePosted = Date(timeIntervalSince1970: emotion.time/1000)
        
        if Date().minutes(from: datePosted) > 60*24{
            button.setAttributedTitle(createDayString(), for: .normal)
        }
        else{
            button.setAttributedTitle(createTimeString(), for: .normal)
        }
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.sizeToFit()
        button.titleLabel?.textAlignment = .center
        button.frame.origin.x = topBottomOffset
        
        emotionLabel.font = emotion.font
        emotionLabel.text = emotion.name
        emotionLabel.textColor = UIColor.white
        emotionLabel.sizeToFit()
        
        emotionLabel.frame.origin.x = button.frame.maxX + 30
        
        emotionLabel.frame.origin.y = topBottomOffset
        button.frame.origin.y = topBottomOffset
        
        
        frame.size.height = max(emotionLabel.frame.maxY,button.frame.maxY) + topBottomOffset
        line.frame.size.width = frame.width
        line.frame.origin.y = frame.size.height - 1
        
        otherLine.frame.size.height = 25
        otherLine.center.y = frame.height/2
        otherLine.frame.origin.x = button.frame.maxX + 10
        
        emotionLabel.center.y = frame.height/2
        button.center.y = frame.height/2
        
        
        if expanded{
            textLabel.isHidden = false
            textLabel.frame.origin.x = button.frame.origin.x
            textLabel.preferredMaxLayoutWidth = width - textLabel.frame.origin.y - 10
            textLabel.frame.size.width = width - textLabel.frame.origin.y - 10
            textLabel.numberOfLines = 0
            textLabel.text = emotion.text
            textLabel.sizeToFit()
            textLabel.frame.origin.y = frame.size.height
            frame.size.height = textLabel.frame.maxY + topBottomOffset
            line.frame.origin.y = frame.size.height - 1
        }
        
        else{
            textLabel.isHidden = true
        }
        
        
    }
    
}
